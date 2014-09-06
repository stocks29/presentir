defmodule Presentir.Tcp.ClientHandler do
  alias Presentir.SlideServer, as: SlideServer

  # def listen_bg(port, supervisor, slide_server) do
  #   Presentir.Tcp.Server.listen_bg(port, supervisor, 
  #     # Handle line
  #     fn (line, client) ->
  #       handler(line, client, slide_server)
  #     end, 

  #     # Handle accept
  #     fn (client -> 
  #       SlideServer.add_client(slide_server, client)
  #     end))
  # end

  # defp accept(port, slide_server) do
  #   {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
  #   IO.puts "Accepting connections on port #{port}"
  #   Task.Supervisor.start_child(Presentir.TaskSupervisor, fn -> 
  #     client_loop_acceptor(socket, slide_server, 0)
  #   end)
  # end

  # defp client_loop_acceptor(socket, slide_server, count) do
  #   handle_accept(:gen_tcp.accept(socket), socket, slide_server, count)
  # end

  # defp handle_accept({:error, :closed}, _socket, _slide_server, _count), do: :ok
  # defp handle_accept({:ok, client}, socket, slide_server, count) do
  #   handle_client(client, slide_server)
  #   new_count = count + 1
  #   IO.puts "client #{new_count} connected"
  #   client_loop_acceptor(socket, slide_server, new_count)
  # end

  # defp handle_client(client, slide_server) do
  #   Task.Supervisor.start_child(Presentir.TaskSupervisor, fn ->
  #     SlideServer.add_client(slide_server, client)
  #     serve(client, slide_server)
  #   end)
  # end

  # defp serve(client, slide_server) do
  #   client
  #   |> read_line()
  #   |> handle_read_line(client, slide_server)
  # end

  # defp read_line(client) do
  #   :gen_tcp.recv(client, 0)
  # end

  def handler(line, client, slide_server), do: handle_read_line(line, client, slide_server)

  defp handle_read_line({:error, :closed}, client, slide_server) do
    SlideServer.remove_client(slide_server, client)
    :stop
  end
  defp handle_read_line({:ok, "q" <> _data}, client, slide_server) do
    SlideServer.remove_client(slide_server, client)
    IO.puts "client disconnected"
    :gen_tcp.send(client, "Bye!\r\n")    
    :gen_tcp.close(client)
    :stop
  end
  defp handle_read_line({:ok, _data}, _client, _slide_server) do
    :ok
  end

end