defmodule Presentir.MainTcpServer do
  alias Presentir.SlideServer, as: SlideServer

  def listen(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false])
    main_loop_acceptor socket
  end

  defp main_loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.Supervisor.start_child(Presentir.TaskSupervisor, fn -> 
      serve(client)
    end)
    main_loop_acceptor(socket)
  end

  defp serve(client) do
    client
    |> read_line()
    |> handle_read_line(client)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp handle_read_line({:error, :closed}, _client) do end

  defp handle_read_line({:ok, "s " <> port}, client) do
    port = port |> String.strip |> String.to_integer
    {:ok, slide_server} = Presentir.SlideSupervisor.start_server(Presentir.test, port)
    :gen_tcp.send(client, "Presentation running on port #{port}\r\n")    
    SlideServer.add_client(slide_server,client)
    Presentir.ControlTcpServer.serve(client, slide_server)
    :gen_tcp.send(client, "Presentation ended on port #{port}\r\n")    
    serve(client)
  end

  defp handle_read_line({:ok, "q" <> _data}, client) do
    :gen_tcp.send(client, "Bye!\r\n")    
    :gen_tcp.close(client)
  end

  defp handle_read_line({:ok, data}, client) do
    :gen_tcp.send(client, "unknown command: #{data}")   
    serve(client)
  end
end
