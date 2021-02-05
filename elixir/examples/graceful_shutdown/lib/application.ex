defmodule GracefulShutdown.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GracefulShutdown.Server
    ]

    opts = [strategy: :one_for_one, name: GracefulShutdown.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
