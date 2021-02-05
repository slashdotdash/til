defmodule GracefulShutdown.Server do
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
