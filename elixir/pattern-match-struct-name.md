# Pattern match struct name

Define one or more Elixir structs:

```elixir
defmodule Foo do
  defstruct [:name]

  def inspect(%Foo{name: name}), do: "Foo<#{name}>"
end

defmodule Bar do
  defstruct [:name]

  def inspect(%Bar{name: name}), do: "Bar<#{name}>"  
end
```

Pattern match on the struct module using `%module{}`:

```elixir
defmodule Inspector do
  def inspect(%module{} = struct), do: module.inspect(struct)
end
```

Usage:

```elixir
Inspector.inspect(%Foo{name: "foo"}) # Foo<foo>
Inspector.inspect(%Bar{name: "bar"}) # Bar<bar>
```

See also [Elixir protocols](https://elixir-lang.org/getting-started/protocols.html) for defining polymorphic behaviour.
