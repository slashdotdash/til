# `GenServer` hibernate after start option

`GenServer` allows the `:hibernate_after` option to be provided to [`GenServer.start_link3/`](https://hexdocs.pm/elixir/GenServer.html#start_link/3`) as described in the documentation:

> `:hibernate_after` - if present, the GenServer process awaits any message for the given number of milliseconds and if no message is received, the process goes into hibernation automatically (by calling `:proc_lib.hibernate/3`).

### Example `GenServer`

Here's a basic ping/pong `GenServer` process which can be used to configure the `hibernate_after` option.

```elixir
defmodule HibernatingServer do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def ping(server) do
    GenServer.call(server, :ping)
  end

  @impl GenServer
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl GenServer
  def handle_call(:ping, _from, state) do
    {:reply, :pong, state}
  end
end
```

#### Usage

Start the `GenServer` process with option to hibernate after 10 seconds:

```elixir
iex> {:ok, pid} = HibernatingServer.start_link(hibernate_after: :timer.seconds(10))
{:ok, #PID<0.134.0>}
```

Initially the process is running the gen server loop:

```elixir
iex> Process.info(pid)
[
  current_function: {:gen_server, :loop, 7},
  initial_call: {:proc_lib, :init_p, 5},
  status: :waiting,
  message_queue_len: 0,
  links: [#PID<0.108.0>],
  dictionary: [
    "$initial_call": {HibernatingServer, :init, 1},
    "$ancestors": [#PID<0.108.0>, #PID<0.81.0>]
  ],
  trap_exit: false,
  error_handler: :error_handler,
  priority: :normal,
  group_leader: #PID<0.64.0>,
  total_heap_size: 233,
  heap_size: 233,
  stack_size: 11,
  reductions: 31,
  garbage_collection: [
    max_heap_size: %{error_logger: true, kill: true, size: 0},
    min_bin_vheap_size: 46422,
    min_heap_size: 233,
    fullsweep_after: 65535,
    minor_gcs: 0
  ],
  suspending: []
]
```

After waiting for more than 10 seconds the process should be hibernated:

```elixir
iex> Process.info(pid)
[
  current_function: {:erlang, :hibernate, 3},
  initial_call: {:proc_lib, :init_p, 5},
  status: :waiting,
  message_queue_len: 0,
  links: [#PID<0.108.0>],
  dictionary: [
    "$initial_call": {HibernatingServer, :init, 1},
    "$ancestors": [#PID<0.108.0>, #PID<0.81.0>]
  ],
  trap_exit: false,
  error_handler: :error_handler,
  priority: :normal,
  group_leader: #PID<0.64.0>,
  total_heap_size: 32,
  heap_size: 32,
  stack_size: 0,
  reductions: 37,
  garbage_collection: [
    max_heap_size: %{error_logger: true, kill: true, size: 0},
    min_bin_vheap_size: 46422,
    min_heap_size: 233,
    fullsweep_after: 65535,
    minor_gcs: 0
  ],
  suspending: []
]
```

Note the process info shows the `total_heap_size`, `heap_size`, and `stack_size` have all been reduced during the process hibernation as a garbage collection has taken place.

Sending a message to the process will start it running again:

```elixir
iex> HibernatingServer.ping(pid)
:pong

iex> Process.info(pid, :current_function)
{:current_function, {:gen_server, :loop, 7}}
```

If no further messages are received within 10 seconds it will hibernate again:

```elixir
iex> Process.info(pid, :current_function)
{:current_function, {:erlang, :hibernate, 3}}
```

The process hibernation will happen again after any 10 second inactivity period when it is running.
