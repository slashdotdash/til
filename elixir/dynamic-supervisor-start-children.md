# Dynamic supervisor start children

How do I start a dynamic supervisor's initial children when it starts?

José Valim [provides a solution](https://elixirforum.com/t/understanding-dynamicsupervisor-no-initial-children/14938/2?u=slashdotdash):

> Start a `DynamicSupervisor` with a Task under a `rest_for_one` supervisor. This way you can start children immediately after the supervisor boots.

### Example

The following module based `DynamicSupervisor` provides a `start_children/0` function which starts one or more existing child processes. It uses a static list, but this could be populated from anywhere.

```elixir
defmodule ExampleDynamicSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl DynamicSupervisor
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_children do
    for child <- [:child1, :child2, :child3] do
      {:ok, _pid} = start_child(child)
    end

    :ok
  end

  def start_child(child) do
    spec = %{
      id: {ChildSupervisor, child},
      start: {ChildSupervisor, :start_link, [child]},
      type: :supervisor
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
```

The above `DynamicSupervisor` can be started by a supervisor in addition to a task which calls the `start_children/0` function. This will asynchronously start all the children _after_ the dynamic supervisor has started.

```elixir
children = [
  ExampleDynamicSupervisor,
  Supervisor.child_spec({Task, &ExampleDynamicSupervisor.start_children/0}, restart: :transient)
]

opts = [strategy: :rest_for_one]

Supervisor.start_link(children, opts)
```

The `rest_for_one` supervisor strategy ensures that if the dynamic supervisor process crashes it will also terminate the task. On restart, both the dynamic supervisor and the task to start all children will be started.
