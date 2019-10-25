# Use Ecto's UTC datetime type

Use Ecto's `utc_datetime` or `utc_datetime_usec` to store timestamps in UTC time as described in [Time zones in PostgreSQL, Elixir and Phoenix](https://www.amberbit.com/blog/2017/8/3/time-zones-in-postgresql-elixir-and-phoenix/).

```elixir
schema "events" do
  field(:starts_at, :utc_datetime)
  field(:ends_at, :utc_datetime)

  timestamps(type: :utc_datetime_usec)
end
```

Note the default type for `timestamps` is `:naive_datetime` unless the `type` option is provided, as shown above. 
