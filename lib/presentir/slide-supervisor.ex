defmodule Presentir.SlideSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def start_server(presentation, port) do
    Supervisor.start_child(__MODULE__, [presentation, port])
  end

  def init(:ok) do
    children = [
      worker(Presentir.SlideServer, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end