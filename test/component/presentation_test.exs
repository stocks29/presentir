defmodule PresentationTest do
  use ExUnit.Case
  alias Presentir.Presentation, as: P
  alias Presentir.Render, as: R
  alias Presentir.Slide, as: S

  test "name is fetchable" do
    assert P.name(P.new("the-name", "the-author")) == "the-name"
  end

  test "author is fetchable" do
    assert P.author(P.new("the-name", "the-author")) == "the-author"
  end

  test "default description is empty string" do
    assert P.description(P.new("the-name", "the-author")) == ""
  end

  test "description is fetchable" do
    assert P.description(P.new("the-name", "the-author", "the-description")) == "the-description"
  end

  test "presentations have a title slide by default" do
    assert length(P.slides(P.new("the-name", "the-author"))) == 1
  end

  test "slides can be added to a presentation" do
    presentation = P.new("the-name", "the-author")
    assert length(P.slides(presentation)) == 1
    presentation = P.add_slide(presentation, S.new("slide-title"))
    assert length(P.slides(presentation)) == 2
  end

  test "presentations can be rendered as text" do
    presentation = P.add_slide(P.new("the-name", "the-author"), S.new("title"))
    assert R.as_text(presentation) == "\nthe-name\n--------\n\n\n\ncreated by the-author\n\npresented " <> now <> "\n\n\n\n\n==================================================\n\n\ntitle\n-----\n\n\n"
  end

  test "presentations can be rendered as html" do
    presentation = P.add_slide(P.new("the-name", "the-author"), S.new("title"))
    assert R.as_html(presentation) == "<section class=\"presentir-slide\"><h1 class=\"presentir-title\">the-name</h1><p class=\"presentir-paragraph\"></p>\n\n<p class=\"presentir-paragraph\">created by the-author</p>\n\n<p class=\"presentir-paragraph\">presented Tuesday, September 16 2014</p>\n\n</section>\n<hr>\n<section class=\"presentir-slide\"><h1 class=\"presentir-title\">title</h1></section>"
  end

  defp now, do: Timex.DateFormat.format!(Timex.Date.local, "%A, %B %e %Y", :strftime)
end
