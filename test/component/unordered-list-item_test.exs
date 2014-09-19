defmodule UnorderedListItemTest do
  use ExUnit.Case
  alias Presentir.UnorderedListItem, as: LI
  alias Presentir.Render, as: R

  test "list items have default content" do
    assert LI.content(LI.new()) == ""
  end

  test "list items can have content" do
    assert LI.content(LI.new("the-content")) == "the-content"
  end

  test "list item can be rendered as text" do
    assert R.as_text(LI.new("the-content")) == "* the-content"
  end

  test "list item can be rendered as html" do
    assert R.as_html(LI.new("the-content")) == "<li>the-content</li>"
  end

end