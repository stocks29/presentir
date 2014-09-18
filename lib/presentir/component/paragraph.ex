defmodule Presentir.Paragraph do
  defstruct content: ""

  def new(content \\ ""), do: %Presentir.Paragraph{content: content}
  def content(paragraph), do: paragraph.content

  defimpl Presentir.Render, for: Presentir.Paragraph do
    def as_text(paragraph), do: Presentir.Render.as_text(paragraph.content) <> "\n"
    def as_html(paragraph), do: "<p class=\"presentir-paragraph\">" <> Presentir.Render.as_html(paragraph.content) <> "</p>\n"
  end
end