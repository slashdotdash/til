# Start an Elixir application's dependencies

Use the [`Application.spec/2` function](https://hexdocs.pm/elixir/Application.html#spec/2) to list the dependencies of an application. This can be useful if you run your tests _without_ starting the application using the `--no-start` ExUnit flag. In the test helper file you can then manually start your application's dependencies without it being started.

```elixir
# test/test_helper.exs
Application.load(:my_app)

for app <- Application.spec(:my_app, :applications) do
  {:ok, _apps} = Application.ensure_all_started(app)
end
```
