defmodule Presentir.Slide do
  defstruct title: "Untitled Slide", content: []

  def new(title, content \\ []) do
    %Presentir.Slide{title: title, content: content} 
  end

  defimpl Presentir.Render, for: Presentir.Slide do
    def as_text(slide) do
      underline = underline(slide.title, "-")
      content = Presentir.Render.as_text(slide.content)
      "\n#{slide.title}\n#{underline}\n\n#{content}\n" 
    end

    defp underline(str, char) do
      Enum.map(String.to_char_list(str), fn(_) -> char end)
    end
  end

end