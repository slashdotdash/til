# Exception message

Use [`Exception.message/1`](https://hexdocs.pm/elixir/Exception.html#message/1) to get a formatted error message.

### Example

Given the following Postgrex error:

```elixir
error = %Postgrex.Error{
  connection_id: 58369,
  message: nil,
  postgres: %{
    code: :duplicate_schema,
    file: "pg_namespace.c",
    line: "63",
    message: "schema \"example\" already exists",
    pg_code: "42P06",
    routine: "NamespaceCreate",
    severity: "ERROR",
    unknown: "ERROR"
  },
  query: nil
}
```

Will produce the message:

```elixir
iex> Exception.message(error)
"ERROR 42P06 (duplicate_schema) schema \"example\" already exists"
```
