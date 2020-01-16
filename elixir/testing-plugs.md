# Testing plugs

Use [`Plug.Test`](https://hexdocs.pm/plug/Plug.Test.html) as a convenience for testing plugs.

```elixir
defmodule PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "POST /foo" do    
    conn =
      conn(:post, "/foo", "")
      |> put_req_header("authorization", "Basic YWxhZGRpbjpvcGVuc2VzYW1l")
      |> put_req_header("content-type", "application/json")
      |> MyPlug.call([])

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == ""
  end
end
```
