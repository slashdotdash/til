# Ecto virtual field

Populate an Ecto virtual field using a left-join query.

The `favorited` field in the article schema is a virtual boolean, defaulted to false:

```elixir
defmodule Blog.Article do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "blog_articles" do
    field :slug, :string
    field :title, :string
    field :body, :string
    field :tags, {:array, :string}
    field :favorite_count, :integer, default: 0
    field :favorited, :boolean, virtual: true, default: false

    timestamps()
  end
end
```

Favorited articles Ecto schema, using a composite primary key:

```elixir
defmodule Blog.FavoritedArticle do
  use Ecto.Schema

  @primary_key false

  schema "blog_favorited_articles" do
    field :article_uuid, :binary_id, primary_key: true
    field :favorited_by_user_uuid, :binary_id, primary_key: true

    timestamps()
  end
end
```

Query to set the `favorited` virtual field by joining between the two tables and detecting the presence of an entry in the favorited table for a given user:

```elixir
import Ecto.Query

from a in Article,
left_join: f in FavoritedArticle, on: [article_uuid: a.uuid, favorited_by_user_uuid: ^user_uuid],
select: %{a | favorited: not is_nil(f.article_uuid)}
```
