defmodule RenderTest do
  use ExUnit.Case
  alias Presentir.Render, as: R

  test "empty list can be rendered as text" do
    assert R.as_text([]) == ""
  end

  test "empty list can be rendered as html" do
    assert R.as_html([]) == ""
  end

  test "non-empty lists can be rendered as text" do
    assert R.as_text(["foo", "bar"]) == "foo\nbar\n"
  end
  
  test "non-empty lists can be rendered as html" do
    assert R.as_html(["foo", "bar"]) == "foo\nbar\n"
  end
  
  test "strings can be rendered as text" do
    assert R.as_text("foo") == "foo"
  end

  test "strings longer than 80 chars are split up with newlines" do
    assert R.as_text("this string is longer than 80 characters so it gets split up at the token right before 80 characters and a newline is inserted") == "this string is longer than 80 characters so it gets split up at the token right\nbefore 80 characters and a newline is inserted"
  end

  test "strings can be rendered as html" do
    assert R.as_html("foo") == "foo"
  end

end