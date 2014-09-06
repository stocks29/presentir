defmodule Presentir.MainTcpServer do
  alias Presentir.SlideServer, as: SlideServer
  alias Presentir.Tcp.Server, as: TcpServer
  alias Presentir.Tcp.SlideControlHandler, as: SlideControlHandler

  def listen(port) do
    TcpServer.listen(port, Presentir.TaskSupervisor, &handler/2)
  end

  def handler(line, client) do
    handle_read_line(line, client)
  end

  defp handle_read_line({:error, :closed}, _client) do end

  defp handle_read_line({:ok, "s " <> port}, client) do
    port |> String.strip |> String.to_integer |> start_server(client)
    :ok
  end

  defp handle_read_line({:ok, "q" <> _data}, client) do
    :gen_tcp.send(client, "Bye!\r\n")    
    :gen_tcp.close(client)
    :stop
  end

  defp handle_read_line({:ok, data}, client) do
    :gen_tcp.send(client, "unknown command: #{data}")   
    :ok
  end

  defp start_server(port, client) do
    {:ok, slide_server} = SlideServer.new(Presentir.presentation, port)
    :gen_tcp.send(client, "Presentation running on port #{port}\r\n")    
    SlideServer.add_client(slide_server, client)
    presentation_control(client, slide_server)
    :gen_tcp.send(client, "Presentation ended on port #{port}\r\n")    
  end

  defp presentation_control(control_client, slide_server) do
    Presentir.Tcp.Server.serve(control_client, fn (line, client) ->
      SlideControlHandler.handler(line, client, slide_server)
    end)
  end

end
