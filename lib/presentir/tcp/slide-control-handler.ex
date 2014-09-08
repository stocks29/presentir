defmodule Presentir.Tcp.SlideControlHandler do
  alias Presentir.SlideServer, as: SlideServer

  def handler(request, client, slide_server) do
    handle_read_line(request, client, slide_server)
  end

  defp handle_read_line({:error, :closed}, _client, _slide_server), do: :stop

  defp handle_read_line({:ok, "\r\n"}, client, slide_server) do
    handle_read_line({:ok, "next"}, client, slide_server)
  end
  defp handle_read_line({:ok, "n" <> _data}, _client, slide_server) do
    SlideServer.next_slide(slide_server)
    :ok
  end

  defp handle_read_line({:ok, "q" <> _data}, _client, slide_server) do
    SlideServer.stop(slide_server)
    :stop
  end

  defp handle_read_line({:ok, "p" <> _data}, _client, slide_server) do
    SlideServer.previous_slide(slide_server)
    :ok
  end

  defp handle_read_line({:ok, "f" <> _data}, _client, slide_server) do
    SlideServer.first_slide(slide_server)
    :ok
  end

  defp handle_read_line({:ok, data}, client, _slide_server) do
    :gen_tcp.send(client, "unknown command: #{data}")   
    :ok
  end
end