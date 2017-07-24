# ExUnit ignore tests

Configure ExUnit to ignore tests tagged with `:skip`, in `test/test_helper.ex`:

```elixir
ExUnit.start(exclude: [:skip])
```

Apply the `:skip` tag to ignore a test:

```elixir
@tag :skip
test "an ignored test" do
  # ...
end
```

Run tests:

```console
$ mix test
Excluding tags: [:skip]

.

Finished in 0.1 seconds
2 tests, 0 failures, 1 skipped
```
