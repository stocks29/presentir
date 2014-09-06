defmodule Presentir.Tcp.Server do

  def listen_bg(port, supervisor, handler, on_accept \\ fn(_) -> :ok end) when is_integer(port) and is_function(handler) and is_atom(supervisor) do
    {:ok, socket} = listen(port)
    Task.Supervisor.start_child(supervisor, fn -> 
      loop_acceptor(socket, supervisor, handler, on_accept)
    end)
    :ok
  end

  def listen(port, supervisor, handler, on_accept \\ fn(_) -> :ok end) when is_integer(port) and is_function(handler) and is_atom(supervisor) do
    {:ok, socket} = listen(port)
    loop_acceptor(socket, supervisor, handler, on_accept)
    :ok
  end

  defp listen(port), do: :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

  defp loop_acceptor(socket, supervisor, handler, on_accept) do
    handle_accept(:gen_tcp.accept(socket), socket, supervisor, handler, on_accept)
  end

  defp handle_accept({:error, :closed}, _socket, _supervisor, _handler, _on_accept), do: :ok
  defp handle_accept({:ok, client}, socket, supervisor, handler, on_accept) do
    Task.Supervisor.start_child(supervisor, fn -> 
      :ok = on_accept.(client)
      serve(client, handler)
    end)
    loop_acceptor(socket, supervisor, handler, on_accept) 
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