defmodule Presentir.Supervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      supervisor(Task.Supervisor, [[name: Presentir.TaskSupervisor]]),
      worker(Task, [Presentir.TcpServer, :listen, [5000]]),
      worker(Presentir.SlideServer, [Presentir.test])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end