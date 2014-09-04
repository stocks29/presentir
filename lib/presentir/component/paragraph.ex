defmodule Presentir.Paragraph do
  defstruct content: ""

  def new(content \\ ""), do: %Presentir.Paragraph{content: content}

  defimpl Presentir.Render, for: Presentir.Paragraph do
    def as_text(paragraph), do: Presentir.Render.as_text(paragraph.content) <> "\n"
    def as_html(paragraph), do: "<p>" <> Presentir.Render.as_html(paragraph.content) <> "</p>\n"
  end
end