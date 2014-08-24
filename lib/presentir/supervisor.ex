defmodule Presentir.Supervisor do
  use Supervisor

  # API
  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  # Callback
  def init([]) do
    children = [
      supervisor(Presentir.SlideSupervisor, []),
      supervisor(Task.Supervisor, [[name: Presentir.TaskSupervisor]]),
      worker(Task, [Presentir.MainTcpServer, :listen, [3000]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end