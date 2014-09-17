defmodule SlideTest do
  use ExUnit.Case
  alias Presentir.Presentation, as: P
  alias Presentir.Render, as: R
  alias Presentir.Slide, as: S

  test "slide title is fetchable" do
    assert S.title(S.new("the-title")) == "the-title"
  end

  test "slides have no content by default" do
    assert length(S.content(S.new("the-title"))) == 0
  end

  test "slide content is fetchable" do
    assert length(S.content(S.new("the-title", ["foo"]))) == 1
  end

  test "content can be added to slides" do
    slide = S.add_content(S.new("the-title", ["foo"]), ["more", "content"])
    assert length(S.content(slide)) == 3
  end

  test "string content can be adde to slides" do
    slide = S.add_content(S.new("the-title", ["foo"]), "more content")
    assert length(S.content(slide)) == 2
  end

  test "slides can be rendered as text" do
    slide = S.add_content(S.new("the-title", ["foo"]), "more content")
    assert R.as_text(slide) == "\nthe-title\n---------\n\nfoo\n\nmore content\n\n\n"
  end

  test "slides can be rendered as html" do
    slide = S.add_content(S.new("the-title", ["foo"]), "more content")
    assert R.as_html(slide) == "<section class=\"presentir-slide\"><h1 class=\"presentir-title\">the-title</h1><p class=\"presentir-paragraph\">foo</p>\n\n<p class=\"presentir-paragraph\">more content</p>\n\n</section>"
  end
end