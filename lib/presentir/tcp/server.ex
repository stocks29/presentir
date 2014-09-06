defmodule Presentir.Tcp.Server do

  # def listen(supervisor, handler) when is_function(handler) and is_atom(supervisor) do
  #   {:ok, socket} = :gen_tcp.listen(0, [:binary, packet: :line, active: false])
  #   {:ok, port} = :inet.port(socket)
  #   Task.Supervisor.start_child(supervisor, fn -> 
  #     loop_acceptor(socket, supervisor, handler)
  #   end)
  #   port
  # end

  def listen(port, supervisor, handler) when is_integer(port) and is_function(handler) and is_atom(supervisor) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    loop_acceptor(socket, supervisor, handler)
    :ok
  end

  defp loop_acceptor(socket, supervisor, handler) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.Supervisor.start_child(supervisor, fn -> 
      serve(client, handler)
    end)
    loop_acceptor(socket, supervisor, handler) 
  end

  def serve(client, handler) do
    client
    |> read_line()
    |> handler.(client)
    |> process_response(client, handler)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp process_response(:ok, client, handler), do: serve(client, handler)
  defp process_response(:stop, _client, _handler), do: :ok

end