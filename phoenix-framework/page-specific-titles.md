# Page specific titles in Phoenix framework

1. Call the `title/2` function from the view module in the layout template:

    ```html
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <title><%= @view_module.title(@view_template, assigns) %></title>
      </head>
    </html>
    ```

2. Add a `title/2` function for each specific page in its view module:

    ```elixir
    defmodule ExampleWeb.ExampleView do
      use ExampleWeb, :view

      def title("show.html", %{post: post}), do: post.title
      def title("new.html", _), do: "Create a post"
    end
    ```

3. Add a fallback `title/2` function used when there is no page specific title:

    ```elixir
    defmodule ExampleWeb.Helpers.Defaults do
      defmacro __using__(_) do
        quote do
          def title(_view_template, _assigns), do: "Welcome to Example"

          defoverridable [title: 2]
        end
      end
    end
    ```

4. Use the defaults module in the Phoenix web module:

```elixir
defmodule ExampleWeb do
  def view do
    quote do
      use Phoenix.View, root: "lib/example_web/templates",
                        namespace: ExampleWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      use ExampleWeb.Helpers.Defaults
    end
  end
end
```

### References

- [SEO Tags In Phoenix](http://blog.danielberkompas.com/2016/01/28/seo-tags-in-phoenix.html)
