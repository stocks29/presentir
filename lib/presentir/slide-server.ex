defmodule Presentir.SlideServer do
  use GenServer
  alias Presentir.Presentation, as: Presentation
  alias Presentir.Slide, as: Slide
  alias Presentir.Render, as: Render


  # API
  def start_link(presentation) do
    GenServer.start_link(__MODULE__, [presentation])
  end

  def first_slide(server) do
    GenServer.cast(server, :first_slide)
  end

  def next_slide(server) do
    GenServer.cast(server, :next_slide)
  end

  def previous_slide(server) do
    GenServer.cast(server, :previous_slide)
  end

  def add_client(server, client) do
    GenServer.cast(server, {:add_client, client})
  end

  def remove_client(server, client) do
    GenServer.cast(server, {:remove_client, client})
  end


  # Callbacks
  def init([presentation]) do
    previous_slides = []
    current_slide = Slide.new("", Render.as_text(presentation))
    next_slides = Presentation.slides(presentation)
    clients = []
    IO.puts "starting presentation server"
    {:ok, {previous_slides, current_slide, next_slides, clients}}
  end

  def handle_cast(:first_slide, state) do
    new_state = go_to_first_slide(state)
    {:noreply, new_state}
  end

  def handle_cast(:next_slide, state) do
    new_state = advance_slide(state)
    {:noreply, new_state}
  end

  def handle_cast(:previous_slide, state) do
    new_state = rollback_slide(state)
    {:noreply, new_state}
  end

  def handle_cast({:add_client, client}, {previous_slides, current_slide, next_slides, clients}) do
    send_slide(current_slide, client)
    {:noreply, {previous_slides, current_slide, next_slides, [client|clients]}}
  end

  def handle_cast({:remove_client, client}, state) do
    new_state = state_without_client(client, state)
    {:noreply, new_state}
  end



  # Internal functions
  defp state_without_client(client, {previous_slides, current_slide, next_slides, clients}) do
    new_clients = Enum.filter(clients, fn (this_client) -> this_client != client end)  
    {previous_slides, current_slide, next_slides, new_clients}
  end

  defp go_to_first_slide({[], current_slide, _next_slides, clients} = state) do
    send_slide(current_slide, clients)
    state
  end
  defp go_to_first_slide({[previous_slide|previous_slides], current_slide, next_slides, clients}) do
    go_to_first_slide({previous_slides, previous_slide, [current_slide|next_slides], clients})
  end

  defp advance_slide({_previous_slides, current_slide, [], clients} = state) do 
    send_slide(current_slide, clients)
    state
  end
  defp advance_slide({previous_slides, current_slide, [next_slide|next_slides], clients}) do
    send_slide(next_slide, clients)
    {[current_slide|previous_slides], next_slide, next_slides, clients}
  end

  defp rollback_slide({[], current_slide, _next_slides, clients} = state) do
    send_slide(current_slide, clients)
    state
  end
  defp rollback_slide({[next_slide|previous_slides], current_slide, next_slides, clients}) do
    send_slide(next_slide, clients)
    {previous_slides, next_slide, [current_slide|next_slides], clients}
  end

  defp send_slide(slide, clients) when is_list(clients) do
    Enum.each(clients, fn(client) -> send_slide(slide, client) end)
  end

  defp send_slide(nil, _client) do end
  defp send_slide(slide, client) do
    spawn fn -> 
      clear client
      :gen_tcp.send(client, Render.as_text(slide))
    end
  end

  defp clear(client) do
    clear_screen client
    move_cursor_to_top_left client
  end

  defp clear_screen(client) do
    str = <<27>> <> "[2J"
    :gen_tcp.send(client, str)
  end

  defp move_cursor_to_top_left(client) do
    str = <<27>> <> "[H"
    :gen_tcp.send(client, str)
  end

end