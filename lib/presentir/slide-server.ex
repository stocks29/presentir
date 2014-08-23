defmodule Presentir.SlideServer do
  use GenServer
  alias Presentir.Presentation, as: Presentation
  alias Presentir.Slide, as: Slide
  alias Presentir.Render, as: Render


  # API
  def start_link(presentation) do
    GenServer.start_link(__MODULE__, [presentation], [name: __MODULE__])
  end

  def next_slide do
    GenServer.cast(__MODULE__, :next_slide)
  end

  def previous_slide do
    GenServer.cast(__MODULE__, :previous_slide)
  end

  def add_client(client) do
    GenServer.cast(__MODULE__, {:add_client, client})
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

  # Internal functions
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
    str = Enum.join(
      Enum.map(Range.new(1,100), fn(_) -> "\n" end),
      "")
    :gen_tcp.send(client, str)
  end

end