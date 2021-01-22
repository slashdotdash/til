# Ecto Repo's connection process

Ecto's Repo doesn't expose the database connection process which is used to access the database. It is hidden internally which connection from the connection pool is being used. However, it is possible to lookup the connection process by using the PID of the Ecto Repo and getting the connection from the process dictionary when running within a checkout or transaction.

1. Use `Repo.checkout/1`:

    ```elixir
    Repo.checkout(fn ->
      %{pid: pool} = Ecto.Adapter.lookup_meta(Repo)

      conn = Process.get({Ecto.Adapters.SQL, pool})

      Postgrex.query(conn, "SELECT NOW();", [], [])
    end)
    ```

2. Use `Repo.transaction/1`:

    ```elixir
    Repo.transaction(fn ->
      %{pid: pool} = Ecto.Adapter.lookup_meta(Repo)

      conn = Process.get({Ecto.Adapters.SQL, pool})

      Postgrex.query(conn, "SELECT NOW();", [], [])
    end)
    ```

3. Use `Ecto.Multi.run/3`:

    ```elixir
    Ecto.Multi.new()
    |> Ecto.Multi.run(:query, fn repo, _changes ->
      %{pid: pool} = Ecto.Adapter.lookup_meta(Repo)

      conn = Process.get({Ecto.Adapters.SQL, pool})

      Postgrex.query(conn, "SELECT NOW();", [], [])
    end)
    |> Repo.transaction()
    ```
