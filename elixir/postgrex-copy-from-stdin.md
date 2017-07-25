# Postgrex copy from STDIN using `Postgrex.stream/4`

[Postgrex.stream/4](https://hexdocs.pm/postgrex/Postgrex.html#stream/4) returns a stream for a query on a database connection. You can use the stream as a `Collectable` to copy data into a table.

The example given in the Postgrex documentation copies data read from a file:

```elixir
Postgrex.transaction(pid, fn(conn) ->
  stream = Postgrex.stream(conn, "COPY posts FROM STDIN", [])
  Enum.into(File.stream!("posts"), stream)
end)
```

By default this uses the text format: fields are tab delimited and rows are separated by a newline character.

### PostgreSQL BINARY format

> The binary format option causes all data to be stored/read as binary format rather than as text. It is somewhat faster than the text and CSV formats, but a binary-format file is less portable across machine architectures and PostgreSQL versions.

To use PostgreSQL's [BINARY format for copying](https://www.postgresql.org/docs/current/static/sql-copy.html) you must implement their file format, and encode each field as binary data according to its exact datatype.

I wanted to implement and benchmark this approach for the Elixir [EventStore](https://github.com/slashdotdash/eventstore) and compare its performance with the existing multirow insert SQL statement.

Below is the `EventStore.Storage.Appender` module that encodes the events to their binary representation, prefixed with the header, and suffixed with the file trailer.

```elixir
defmodule EventStore.Storage.Appender do
  @moduledoc """
  Append-only storage of events to a stream
  """

  require Logger

  @doc """
  Append the given list of events to the given stream.

  Returns `{:ok, count}` on success, where count indicates the number of appended events.
  """
  def append(conn, stream_id, events) do
    conn
    |> stream_events_into_table(events)
    |> handle_response(stream_id, events)
  end

  @header ["PGCOPY\n\xff\r\n\0\0\0\0\0\0\0\0\0\0"]
  @trailer [<<-1 :: signed-16>>]

  def stream_events_into_table(conn, events) do
    try do
      Postgrex.transaction(conn, fn (conn) ->
        stream = Postgrex.stream(conn, "COPY events(event_id, stream_id, stream_version, event_type, correlation_id, causation_id, data, metadata, created_at) FROM STDIN (FORMAT BINARY)", [], max_rows: 0)

        events
        |> pg_copy_stream()
        |> Enum.into(stream)
      end)
    rescue
      error -> {:error, error}
    end
  end

  def pg_copy_stream(events) do
    [@header, encode_events(events), @trailer]
    |> Stream.concat()
  end

  defp encode_events(events) do
    events
    |> Stream.flat_map(&encode/1)
    |> Stream.drop(-1)
  end

  defp encode(event) do
    [
      <<9>>,
      <<8 :: signed-32, event.event_id :: signed-64>>,
      <<8 :: signed-32, event.stream_id :: signed-64>>,
      <<8 :: signed-32, event.stream_version :: signed-64>>,
      <<byte_size(event.event_type) :: signed-32>>, event.event_type,
      <<byte_size(event.correlation_id) :: signed-32>>, event.correlation_id,
      <<byte_size(event.causation_id) :: signed-32>>, event.causation_id,
      <<byte_size(event.data) :: signed-32>>, event.data,
      <<byte_size(event.metadata) :: signed-32>>, event.metadata,
      encode_date(event.created_at),
      "\0",
    ]
  end

  @gs_epoch :calendar.datetime_to_gregorian_seconds({{2000, 1, 1}, {0, 0, 0}})

  defp encode_date(%NaiveDateTime{year: year, month: month, day: day, hour: hour, minute: min, second: sec, microsecond: {usec, _}}) do
    datetime = {{year, month, day}, {hour, min, sec}}
    secs = :calendar.datetime_to_gregorian_seconds(datetime) - @gs_epoch
    <<8 :: signed-32, secs * 1_000_000 + usec :: signed-64>>
  end

  defp handle_response({:ok, %Postgrex.Stream{}}, stream_id, events) do
    event_count = length(events)
      _ = Logger.info(fn -> "appended #{event_count} event(s) to stream id #{stream_id}" end)
    {:ok, event_count}
  end

  defp handle_response({:error, %Postgrex.Error{postgres: %{code: :foreign_key_violation, message: message}}}, stream_id, _events) do
    _ = Logger.warn(fn -> "failed to append events to stream id #{stream_id} due to: #{inspect message}" end)
    {:error, :stream_not_found}
  end

  defp handle_response({:error, %Postgrex.Error{postgres: %{code: :unique_violation, message: message}}}, stream_id, _events) do
    _ = Logger.warn(fn -> "failed to append events to stream id #{stream_id} due to: #{inspect message}" end)
    {:error, :wrong_expected_version}
  end

  defp handle_response({:error, reason}, stream_id, _events) do
    _ = Logger.warn(fn -> "failed to append events to stream id #{stream_id} due to: #{inspect reason}" end)
    {:error, reason}
  end
end
```

For the typical use case of the EventStore, appending fewer than 100 events at a time, it was *twice as slow* as using a multirow SQL insert statement.

Using `COPY FROM STDIN` should only be used for large data imports.
