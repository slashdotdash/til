# Graceful shutdown

Erlang versions 20 and newer have support for UNIX signal handling. This allows Elixir to support graceful shutdown by sending the `SIGTERM` signal to an Elixir operating system process. The default behaviour when receiving this signal is to call `init:stop/0` to stop the BEAM VM.

Start an `iex` shell:

```shell
$ iex
```

Send `SIGTERM` signal to the Elixir (`iex`) process:

```shell
kill -s TERM <process_id>
```

Note: You can use `ps aux | grep iex` to identify the process id.

This will cause the Elixir shell to shutdown:

```
Interactive Elixir (1.11.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
[info]  SIGTERM received - shutting down
```

The `GenServer` behaviour includes a `terminate/2` callback function which can be used to gracefully shutdown the process when it has been started by an Elixir application's supervision tree.

```elixir
defmodule GracefulShutdownServer do
  use GenServer

  def start_link(opts \\ []) do    
    GenServer.start_link(__MODULE__, [], opts)
  end

  @impl GenServer
  def init(init_arg) do
    Process.flag(:trap_exit, true)
    {:ok, init_arg}
  end

  @impl GenServer
  def terminate(reason, state) do
    IO.puts("GracefulShutdownServer is shutting down due to: " <> inspect(reason))
    state
  end
end
```

Note the `GenServer` process _must_ trap exits for the `terminate/2` callback to be called.

See the [graceful_shutdown example](elixir/examples/graceful_shutdown)
