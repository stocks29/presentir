defmodule Presentir.Tcp.Client do
  alias Presentir.Render, as: Render

  defstruct socket: nil

  def new(socket), do: %Presentir.Tcp.Client{socket: socket}

  defimpl Presentir.Client, for: Presentir.Tcp.Client do
    def send_slide(client, slide) do
      send_data client, Render.as_text(slide)
    end

    def send_message(client, message) do
      send_data client, "#{message}\r\n"
    end

    def disconnect(client), do: :gen_tcp.close(client.socket)

    defp send_data(client, message) do
      clear client.socket
      handle_send(:gen_tcp.send client.socket, message)
    end

    defp handle_send(:ok), do: :ok
    defp handle_send({:error, _}), do: :error
    defp handle_send(result), do: IO.puts "GOT RESULT: #{result}"

    defp clear(client) do
      clear_screen client
      move_cursor_to_top_left client
    end

    defp clear_screen(client) do
      str = <<27>> <> "[2J"
      :gen_tcp.send client, str
    end

    defp move_cursor_to_top_left(client) do
      str = <<27>> <> "[H"
      :gen_tcp.send client, str
    end
  end 
end