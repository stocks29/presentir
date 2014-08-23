defmodule Presentir.TcpServer do
  alias Presentir.SlideServer, as: SlideServer

  def listen(port) do
    # Task.Supervisor.start_child(Presentir.TaskSupervisor, fn ->
      accept(port)
    # end)
  end

  defp accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false])
    IO.puts "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.Supervisor.start_child(Presentir.TaskSupervisor, fn -> 
      IO.puts "client connected"
      SlideServer.add_client(client)
      serve(client)
    end)
    loop_acceptor(socket)
  end

  defp serve(client) do
    client
    |> read_line()
    |> handle_read_line(client)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp handle_read_line({:error, :closed}, _client) do
    # TODO: Remove the client from the slide server
  end

  defp handle_read_line({:ok, "\r\n"}, client) do
    handle_read_line({:ok, "next"}, client)
  end
  defp handle_read_line({:ok, "n" <> _data}, client) do
    IO.puts "advancing slide"
    SlideServer.next_slide
    serve(client)
  end

  defp handle_read_line({:ok, "q" <> _data}, client) do
    # TODO: Should remove from server...
    IO.puts "client disconnected"
    :gen_tcp.send(client, "Bye!\r\n")    
    :gen_tcp.close(client)
  end

  defp handle_read_line({:ok, "p" <> _data}, client) do
    IO.puts "rolling back slide"
    SlideServer.previous_slide
    serve(client)
  end

  defp handle_read_line({:ok, data}, client) do
    data = String.strip(data) 
    IO.puts "got: #{data}"
    serve(client)
  end
end