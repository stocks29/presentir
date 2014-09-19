defmodule TestClient do
  defstruct on_call: nil

  def new(func \\ fn(_got) -> end), do: %TestClient{on_call: func}

  defimpl Presentir.Client, for: TestClient do
    def send_message(client, message), do: client.on_call.(message)
    def send_slide(client, slide), do: client.on_call.(slide)
    def disconnect(client), do: client.on_call.(:disconnect)
  end
end

defmodule SlideServerTest do
  use ExUnit.Case
  alias Presentir.SlideServer, as: Server
  alias Presentir.Presentation, as: Presentation
  alias Presentir.Slide, as: Slide

  setup do
    {:ok, server} = Server.new(presentation)
    {:ok, server: server}
  end 

  test "initial slide is the title slide", context do
    assert length(Slide.content(Server.current_slide(context[:server]))) == 3
  end

  test "client can be added", context do
    assert Server.client_count(context[:server]) == 0
    assert Server.add_client(context[:server], TestClient.new()) == :ok
    assert Server.client_count(context[:server]) == 1
  end

  test "client can be removed", context do
    assert Server.client_count(context[:server]) == 0
    client = TestClient.new
    assert Server.add_client(context[:server], client) == :ok
    assert Server.client_count(context[:server]) == 1
    assert Server.remove_client(context[:server], client) == :ok
    assert Server.client_count(context[:server]) == 0
  end

  test "can advance to next slide", context do
    assert Server.next_slide(context[:server]) == :ok
    assert Server.next_slide(context[:server]) == :ok
    assert Server.current_slide(context[:server]) == second_slide
  end

  test "client receives next slide during advance", context do
    assert Server.next_slide(context[:server]) == :ok
    client = TestClient.new(fn(got) -> 
      assert Enum.any?([first_slide, second_slide], fn(expected) ->
        got == expected
      end)
    end)
    assert Server.add_client(context[:server], client) == :ok
    assert Server.next_slide(context[:server]) == :ok
  end

  test "client receives previous slide when moving to previous slide", context do
    assert Server.next_slide(context[:server]) == :ok
    assert Server.next_slide(context[:server]) == :ok
    client = TestClient.new(fn(got) -> 
      assert Enum.any?([first_slide, second_slide], fn(expected) ->
        got == expected
      end)
    end)
    assert Server.add_client(context[:server], client) == :ok
    assert Server.previous_slide(context[:server]) == :ok
  end

  test "can move back to previous slide", context do
    Server.next_slide(context[:server])
    Server.next_slide(context[:server])
    Server.previous_slide(context[:server])
    assert Server.current_slide(context[:server]) == first_slide
  end

  test "can get id/uuid", context do
    assert Server.id(context[:server]) != nil
  end

  test "can stop server", context do
    assert Process.alive?(context[:server]) == true
    assert Server.stop(context[:server]) == :ok
    :timer.sleep(100) # give the process a moment to shut down since call is async
    assert Process.alive?(context[:server]) == false
  end

  test "client receives disconnect on stop", context do
    assert Server.next_slide(context[:server]) == :ok
    client = TestClient.new(fn(got) -> 
      assert Enum.any?([first_slide, "The presentation has ended", :disconnect], fn(expected) ->
        got == expected
      end)
    end)
    assert Server.add_client(context[:server], client) == :ok
    assert Server.stop(context[:server]) == :ok
  end

  test "can move directly to very first/title slide", context do
    title_slide = Server.current_slide(context[:server])
    assert Server.next_slide(context[:server]) == :ok
    assert Server.next_slide(context[:server]) == :ok
    assert Server.current_slide(context[:server]) != title_slide
    assert Server.first_slide(context[:server]) == :ok
    assert Server.current_slide(context[:server]) == title_slide
  end

  defp presentation, do: Presentation.new(title, author, description, [first_slide, second_slide])
  defp title, do: "the-presentation"
  defp author, do: "the-author"
  defp description, do: "the-description"
  defp first_slide, do: Slide.new("slide1") 
  defp second_slide, do: Slide.new("slide2") 

end