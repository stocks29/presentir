defmodule Presentir do
  alias Presentir.Presentation, as: Presentation
  alias Presentir.Slide, as: Slide
  alias Presentir.Render, as: Render
  alias Presentir.UnorderedList, as: UL

  def test do
    presentation = Presentation.new("Functional Functional Programming", "Bob Stockdale", slides)
    # IO.puts Presentir.Render.as_text(presentation)
    # IO.puts Render.as_text(Presentation.slides(presentation))
    presentation
  end

  defp slides() do
    Enum.take_while(
      Enum.map(Range.new(1,20), fn(i) -> slide(i) end),
      fn(i) -> i end)
  end

  defp slide(1) do
    Slide.new("Intro to Functional Programming", [
      "Functional programming is about composing many small functions to build programs",
      UL.new(["Foo", "Bar"]),
      "Other text here", 
      UL.new(["Baz", "Quux"]) ])   
  end

  defp slide(2) do
    Slide.new("Slide 2")
  end

  defp slide(3) do
    Slide.new("Slide 3")
  end

  defp slide(_) do
    false
  end

end
