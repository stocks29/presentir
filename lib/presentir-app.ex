defmodule PresentirApp do
  use Application

  def start(_type, _args) do
    Presentir.Supervisor.start_link
  end

end
