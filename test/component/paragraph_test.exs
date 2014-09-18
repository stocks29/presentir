defmodule ParagraphTest do
  use ExUnit.Case
  alias Presentir.Render, as: R
  alias Presentir.Paragraph, as: P

  test "content defaults to empty string" do
    assert P.content(P.new()) == ""
  end

  test "content is fetchable" do
    assert P.content(P.new("the-content")) == "the-content"
  end

  test "paragraph can be rendered as text" do
    assert R.as_text(P.new("the-content")) == "the-content\n"
  end

  test "paragraph can be rendered as html" do
    assert R.as_html(P.new("the-content")) == "<p class=\"presentir-paragraph\">the-content</p>\n"
  end
end