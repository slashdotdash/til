# ExUnit assert match

Use [`match?/2`](https://hexdocs.pm/elixir/Kernel.html#match?/2) to assert or refute whether a pattern matches an expression.

```elixir
assert match?({:ok, _}, some_fun())
refute match?({:ok, _}, some_fun())
```

Attempting to do `assert {:ok, _} = some_fun()` will return a Dialyzer error:

```
The guard clause:

_ :: {:ok, _}

===

false

can never succeed.
```
