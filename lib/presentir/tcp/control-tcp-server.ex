defmodule Presentir.ControlTcpServer do
  alias Presentir.SlideServer, as: SlideServer

  def serve(client, slide_server) do
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

  defp handle_read_line({:ok, "q" <> _data}, _client, slide_server) do
    SlideServer.stop(slide_server)
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