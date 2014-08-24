defmodule Presentir.MasterTcpServer do
  alias Presentir.SlideServer, as: SlideServer

  def listen(master_port, client_port, slide_server) do
    accept(master_port, slide_server)
    Presentir.ClientTcpServer.listen(client_port, slide_server)
  end

  defp accept(port, slide_server) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false])
    Task.Supervisor.start_child(Presentir.TaskSupervisor, fn -> 
      master_loop_acceptor(socket, slide_server)
    end)
  end

  defp master_loop_acceptor(socket, slide_server) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.Supervisor.start_child(Presentir.TaskSupervisor, fn -> 
      SlideServer.add_client(slide_server, client)
      serve(client, slide_server)
    end)
    master_loop_acceptor(socket, slide_server)
  end

  defp serve(client, slide_server) do
    client
    |> read_line()
    |> handle_read_line(client, slide_server)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp handle_read_line({:error, :closed}, client, slide_server) do
    SlideServer.remove_client(slide_server, client)
  end

  defp handle_read_line({:ok, "\r\n"}, client, slide_server) do
    handle_read_line({:ok, "next"}, client, slide_server)
  end
  defp handle_read_line({:ok, "n" <> _data}, client, slide_server) do
    SlideServer.next_slide(slide_server)
    serve(client, slide_server)
  end

  defp handle_read_line({:ok, "q" <> _data}, client, slide_server) do
    SlideServer.remove_client(slide_server, client)
    :gen_tcp.send(client, "Bye!\r\n")    
    :gen_tcp.close(client)
  end

  defp handle_read_line({:ok, "p" <> _data}, client, slide_server) do
    SlideServer.previous_slide(slide_server)
    serve(client, slide_server)
  end

  defp handle_read_line({:ok, "f" <> _data}, client, slide_server) do
    SlideServer.first_slide(slide_server)
    serve(client, slide_server)
  end

  defp handle_read_line({:ok, data}, client, slide_server) do
    :gen_tcp.send(client, "unknown command: #{data}")   
    serve(client, slide_server)
  end
end