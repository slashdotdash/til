# Running Observer on a remote node deployed with Distillery

Include `:runtime_tools` in the `extra_applications` section of `mix.exs`:

```elixir
def application do
  [
    mod: {Example.Web, []},
    env: [environment_name: Mix.env],
    extra_applications: [
      :logger,
      :runtime_tools,
    ],
  ]
end
```

Or in the Distillery `rel/config.exs` configuration file:

```elixir
release :example_app do
  set version: "1.2.3"
  set applications: [
    example_web: :permanent,
    runtime_tools: :temporary,
  ]
end
```

Discover the deployed app's local port number via `epmd`:

```console
$ ssh remotehost "epmd -names"
epmd: up and running on port 4369 with data:
name example_app at port 39593
```

Replace `remotehost` with remote host name or IP address.

Start an SSH connection and tunnel epmd and your remote app's ports locally:

```console
ssh -L 4369:localhost:4369 -L 39593:localhost:39593 remotehost
```

Locate and copy the Erlang host cookie set by Distillery in `builds/_build/prod/example_app/releases/1.2.3/vm.args`

Start an `iex` console using the cookie located above:

```console
$ iex --name debug@127.0.0.1 --hidden --cookie cookie
```

Connect to the remote node and start an observer.

```
iex> Node.connect(:"example_app@127.0.0.1")
iex> :observer.start()
```

 You can then connect to the remote node from the Observer "Nodes" menu.
