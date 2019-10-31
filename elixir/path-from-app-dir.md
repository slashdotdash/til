# Read from the application's directory

Use [`Application.app_dir/2`](https://hexdocs.pm/elixir/Application.html#app_dir/2) to construct a path relative to the application's directory, such as `/priv`:

```elixir
path = Application.app_dir(:myapp, "priv")
```

This will be `/priv` when run in the `myapp` project. It will also work when the project is referenced as a dependency in another project.

Ensure you include `priv` in the project package inside `mix.exs`:

```elixir
defp package do
  [
    files: ["lib", "priv"],
    # ...
  ]
  end
```
