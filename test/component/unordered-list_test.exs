defmodule UnorderedListTest do
  use ExUnit.Case
  alias Presentir.Render, as: R
  alias Presentir.UnorderedListItem, as: LI
  alias Presentir.UnorderedList, as: UL

  test "can create empty unordered list" do
    assert length(UL.items(UL.new())) == 0
  end

  test "can create unordered list with items" do
    assert length(UL.items(UL.new(["foo"]))) == 1
  end

  test "can get items from list" do
    list = UL.add_items(UL.add_item(UL.new(["foo"]), "bar"), ["baz", "quux"])
    [first|[second|[third|[fourth|[]]]]] = UL.items(list)
    assert LI.content(first) == "foo"
    assert LI.content(second) == "bar"
    assert LI.content(third) == "baz"
    assert LI.content(fourth) == "quux"
  end

  test "text items are automatically converted to list items" do
    assert LI.content(List.first(UL.items(UL.new(["foo"])))) == "foo"
  end

  test "can add text item" do
    assert LI.content(List.first(UL.items(UL.add_item(UL.new(), "foo")))) == "foo"
  end

  test "can add list of items" do
    assert length(UL.items(UL.add_items(UL.new(), ["foo", "bar"]))) == 2
  end

  test "unordered list can be rendered as text" do
    assert R.as_text(UL.new(["foo", "bar"])) == "    * foo\n\n    * bar"
  end

  test "unordered list can be rendered as html" do
    assert R.as_html(UL.new(["foo", "bar"])) == "<ul class=\"presentir-list\"><li>foo</li>\n<li>bar</li>\n</ul>"
  end
end