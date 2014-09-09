defmodule Presentir.SlideServer do
  use GenServer
  alias Presentir.Presentation, as: Presentation
  

  # API
  def new(presentation) do
    Presentir.SlideSupervisor.start_server(presentation)
  end

  def start_link(presentation) do
    uuid = UUID.uuid4() 
    GenServer.start_link(__MODULE__, [presentation, uuid], name: {:global, uuid})
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

  def stop(server, message \\ "The presentation has ended") do
    GenServer.cast(server, {:stop, message})
  end


  # Callbacks
  def init([presentation, uuid]) do
    [current_slide|next_slides] = Presentation.slides(presentation)
    previous_slides = []
    clients = []
    IO.puts "Starting presentation server #{inspect self()} -> #{uuid}"
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
    communicate(send_slide(current_slide), client)
    {:noreply, {previous_slides, current_slide, next_slides, [client|clients]}}
  end

  def handle_cast({:remove_client, client}, state) do
    new_state = state_without_client(client, state)
    {:noreply, new_state}
  end

  def handle_cast({:stop, message}, state = {_, _, _, clients}) do
    Enum.each(clients, fn (client) ->
      communicate(fn(client) ->
        send_message(message).(client)
        # TODO: Sleep??
        disconnect.(client)
      end, client)
    end)
    IO.puts "Stopping presentation server #{inspect self()}"
    {:stop, :normal, state}
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
    Enum.each(clients, fn(client) -> communicate(send_slide(slide), client) end)
  end

  defp communicate(do_comm, client) when is_function(do_comm) do
    spawn fn ->
      handle_send_result(do_comm.(client), client)
    end
  end

  defp send_slide(nil) do fn -> :ok end end
  defp send_slide(slide) do
    fn(client) -> 
      Presentir.Client.send_slide(client, slide)
    end
  end

  defp send_message(message) do
    fn(client) -> 
      Presentir.Client.send_message(client, message)
    end
  end

  defp disconnect do
    fn(client) -> 
      Presentir.Client.disconnect(client) 
    end
  end

  defp handle_send_result(:ok, _client), do: :ok
  defp handle_send_result(_, client) do 
    IO.puts "removing dead client"
    remove_client(client)
  end

  defp remove_client(client) do
    remove_client(self(), client) 
  end

end