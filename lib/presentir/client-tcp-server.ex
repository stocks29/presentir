defmodule Presentir.ClientTcpServer do
  alias Presentir.SlideServer, as: SlideServer

  def listen(port, slide_server) do
    accept(port, slide_server)
  end

  defp accept(port, slide_server) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false])
    IO.puts "Accepting connections on port #{port}"
    Task.Supervisor.start_child(Presentir.TaskSupervisor, fn -> 
      client_loop_acceptor(socket, slide_server, 0)
    end)
  end

  defp client_loop_acceptor(socket, slide_server, count) do
    {:ok, client} = :gen_tcp.accept(socket)
    handle_client(client, slide_server)
    new_count = count + 1
    IO.puts "client #{new_count} connected"
    client_loop_acceptor(socket, slide_server, new_count)
  end

  defp handle_client(client, slide_server) do
    Task.Supervisor.start_child(Presentir.TaskSupervisor, fn ->
      SlideServer.add_client(slide_server, client)
      serve(client, slide_server)
    end)
  end

  defp serve(client, slide_server) do
    client
    |> read_line()
    |> handle_read_line(client, slide_server)
  end

  defp read_line(client) do
    :gen_tcp.recv(client, 0)
  end

  defp handle_read_line({:error, :closed}, client, slide_server) do
    SlideServer.remove_client(slide_server, client)
  end
  defp handle_read_line({:ok, "q" <> _data}, client, slide_server) do
    SlideServer.remove_client(slide_server, client)
    IO.puts "client disconnected"
    :gen_tcp.send(client, "Bye!\r\n")    
    :gen_tcp.close(client)
  end
  defp handle_read_line({:ok, _data}, client, slide_server) do
    serve client, slide_server
  end

end