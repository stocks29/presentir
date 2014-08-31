defmodule Presentir.Paragraph do
  defstruct content: ""

  def new(content \\ ""), do: %Presentir.Paragraph{content: content}

  defimpl Presentir.Render, for: Presentir.Paragraph do
    def as_text(paragraph), do: Presentir.Render.as_text(paragraph.content) <> "\n"
  end
end