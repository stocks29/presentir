defmodule Presentir.Tcp.SlideControlHandler do
  alias Presentir.SlideServer, as: SlideServer

  def handler(request, client, slide_server) do
    handle_read_line(request, client, slide_server)
  end

  defp handle_read_line({:error, :closed}, _client, _slide_server), do: :stop

  defp handle_read_line({:ok, "\r\n"}, client, slide_server) do
    handle_read_line({:ok, "next"}, client, slide_server)
  end
  defp handle_read_line({:ok, "n" <> _}, _client, slide_server) do
    SlideServer.next_slide(slide_server)
    :ok
  end

  defp handle_read_line({:ok, "q" <> _}, _client, slide_server) do
    SlideServer.stop(slide_server)
    :stop
  end

  defp handle_read_line({:ok, "p" <> _}, _client, slide_server) do
    SlideServer.previous_slide(slide_server)
    :ok
  end

  defp handle_read_line({:ok, "f" <> _}, _client, slide_server) do
    SlideServer.first_slide(slide_server)
    :ok
  end

  defp handle_read_line({:ok, "i" <> _}, client, slide_server) do
    id = SlideServer.id(slide_server)
    :gen_tcp.send(client, "id: #{id}")
    :ok
  end

  defp handle_read_line({:ok, data}, client, _slide_server) do
    :gen_tcp.send(client, "unknown command: #{data}")   
    :ok
  end
end