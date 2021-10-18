# ExUnit capture log level

Configure the logging level when capturing log messages with ExUnit:

```elixir
# config/test.exs
config :ex_unit, capture_log: [level: :warn]
```

See [`ExUnit.configure/1`](https://hexdocs.pm/ex_unit/ExUnit.html#configure/1)
