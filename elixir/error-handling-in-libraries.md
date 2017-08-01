# Error handling in Elixir libraries

- Use `{:ok, value}` and `{:error, reason}` tagged tuples.
- Optionally provide *bang* functions (e.g. `foo/1` and `foo!/1`) that raise exceptions.
- Consider using a custom exception struct for the library.

Example error handling for an Elixir library as [suggested by Michał Muskała](http://michal.muskala.eu/2017/02/10/error-handling-in-elixir-libraries.html):

```elixir
defmodule YourLibrary do
  defmodule Error do
    defexception [:reason]

    def exception(reason),
      do: %__MODULE__{reason: reason}

    def message(%__MODULE__{reason: reason}),
      do: YourLibrary.format_error(reason)
  end

  def get_one(1),
    do: {:ok, "one"}
  def get_one(value),
    do: {:error, {:not_one, value}}

  def get_one!(arg) do
    case get_one(arg) do
      {:ok, value} -> value
      {:error, reason} -> raise Error, reason
    end
  end

  def format_error({:not_one, value}),
    do: "#{inspect value} is not one"
end
```
