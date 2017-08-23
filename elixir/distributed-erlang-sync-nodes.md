# Distributed Erlang sync nodes

In a [distributed Erlang application](http://erlang.org/doc/design_principles/distributed_applications.html) you can configure nodes to wait for at start up, during cluster formation, before starting your own application.

You configure the `:kernel` application:

```elixir
config :kernel,
  sync_nodes_optional: [:"node1@192.168.1.1", :"node2@192.168.1.2"],
  sync_nodes_timeout: 60_000
```

The `sync_nodes_optional` configuration specifies which nodes to attempt to connect to within the `sync_nodes_timeout` window, defined in milliseconds, before continuing with startup.

There is also a `sync_nodes_mandatory` setting which can be used to enforce all nodes are connected within the timeout window or else the node terminates.

## `iex` usage

Create a `sys.config` file per node:

- `node1.sys.config`

    ```
    [{kernel,
      [
        {sync_nodes_optional, ['node2@127.0.0.1', 'node3@127.0.0.1']},
        {sync_nodes_timeout, 30000}
      ]}
    ].
    ```

- `node2.sys.config`

    ```
    [{kernel,
      [
        {sync_nodes_optional, ['node1@127.0.0.1', 'node3@127.0.0.1']},
        {sync_nodes_timeout, 30000}
      ]}
    ].
    ```

- `node3.sys.config`

    ```
    [{kernel,
      [
        {sync_nodes_optional, ['node1@127.0.0.1', 'node2@127.0.0.1']},
        {sync_nodes_timeout, 30000}
      ]}
    ].
    ```

Run an `iex` console, one for each node:

```console
$ MIX_ENV=test iex --name node1@127.0.0.1 --erl "-config node1.sys.config" -S mix
```

```console
$ MIX_ENV=test iex --name node2@127.0.0.1 --erl "-config node2.sys.config" -S mix
```

```console
$ MIX_ENV=test iex --name node3@127.0.0.1 --erl "-config node3.sys.config" -S mix
```

Once the third `iex` console has started, within the 30 second timeout, the three nodes will connect and then start your application.

You can verify the nodes are connected to each other:

```
iex> Node.list()
[:"node2@127.0.0.1", :"node3@127.0.0.1"]
```
