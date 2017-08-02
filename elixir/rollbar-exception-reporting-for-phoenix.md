# Rollbar exception reporting for Phoenix

Install the [rollbax](https://hex.pm/packages/rollbax) exception tracking and logging library.

Configure Rollbar in `config/config.exs`:

```elixir
config :rollbax,
  access_token: "<<access_token>>",
  environment: "production"

config :logger,
  backends: [:console, Rollbax.Logger]
```

Enable Rollbar error logging in production environment (`config/prod.exs`):

```elixir
config :logger, Rollbax.Logger,
  level: :error
```

Use Rollbar console logging mode in development (`config/dev.exs`):

```elixir
config :rollbax, enabled: :log
```

Disable Rollbar logging for tests (`config/test.exs`):

```elixir
config :rollbax, enabled: false
```

Add `Plug.ErrorHandler` to your web router module and report errors to Rollbar:

```elixir
defmodule ExampleWeb.Router do
  use ExampleWeb, :router
  use Plug.ErrorHandler

  # Ignore Phoenix routing errors
  defp handle_errors(_conn, %{reason: %Phoenix.Router.NoRouteError{}}), do: :ok

  # Log all other errors to Rollbar
  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    conn =
      conn
      |> Plug.Conn.fetch_cookies()
      |> Plug.Conn.fetch_query_params()

    conn_data = %{
      "request" => %{
        "cookies" => conn.req_cookies,
        "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
        "user_ip" => (conn.remote_ip |> Tuple.to_list() |> Enum.join(".")),
        "headers" => Enum.into(conn.req_headers, %{}),
        "params" => conn.params,
        "method" => conn.method,
      }
    }

    Rollbax.report(kind, reason, stacktrace, %{}, conn_data)
  end
end
```

Note I've chosen to ignore Phoenix's no route errors.
