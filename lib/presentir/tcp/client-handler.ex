defmodule Presentir.Tcp.ClientHandler do
  alias Presentir.SlideServer, as: SlideServer

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