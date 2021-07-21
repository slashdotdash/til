# Ecto stream to list

```elixir
@spec stream_to_list(Ecto.Queryable.t(), Keyword.t()) :: {:ok, Enum.t()} | {:error, any}
defp stream_to_list(queryable, opts) do
  stream = Repo.stream(queryable, opts)

  Repo.transaction(fn -> Enum.to_list(stream) end, opts)
end
```
