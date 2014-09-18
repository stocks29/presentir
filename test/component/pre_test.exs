defmodule PreTest do
  use ExUnit.Case
  alias Presentir.Pre, as: Pre
  alias Presentir.Render, as: R

  test "can create pre" do
    assert Pre.content(Pre.new("foo")) == "foo"
  end

  test "pre can be rendered as text" do
    assert R.as_text(Pre.new("foo")) == "foo"
  end

  test "pre can be rendered as html" do
    assert R.as_html(Pre.new("foo")) == "<pre class=\"presentir-pre\">foo</pre>"
  end

end