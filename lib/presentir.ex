defmodule Presentir do
  alias Presentir.Presentation, as: Presentation
  alias Presentir.Slide, as: Slide
  alias Presentir.UnorderedList, as: UL

  def test do
    presentation = Presentation.new("Functional Functional Programming", "Bob Stockdale", slides)
    # IO.puts Presentir.Render.as_text(presentation)
    # IO.puts Render.as_text(Presentation.slides(presentation))
    presentation
  end

  defp slides() do
    Enum.map(slide_order, fn(name) -> slide(name) end)
  end

  defp slide_order do
    [
      :goals,
      :intro
    ]
  end

  defp slide(:goals) do
    Slide.new("Goals of this LnL", [
      "What I hope to accomplish with this LnL",
      UL.new([
        "Basic understanding of functional programming",
        "Insight into the benefits of functional programming",
        "Concepts that you can take back any apply to your software"
        ])
      ])
  end

  defp slide(:intro) do
    Slide.new("Intro to Functional Programming", [
      UL.new([
        "Style of building computer programs",
        "Based on lamda calculus",
        UL.new([
          "\"Provides a theoretical framework for describing functions and their evaluation\""
          ]),
        "Avoids state and mutable data",
        "Declarative - programming is done with expressions",
        "Eliminating side effects",
        UL.new([
          "changes in state that don't depend on function inputs"
          ]),
        "Functional programs are generally easier to understand and reason about"
        ])
      ])
  end

  defp slide(_) do
    Slide.new("404", [
      "This is not the slide you're looking for"
      ])
  end

end
