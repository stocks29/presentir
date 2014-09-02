defmodule Presentir.Slide do
  defstruct title: "Untitled Slide", content: []

  def new(title, content \\ []) do
    %Presentir.Slide{title: title} |> add_content(content)
  end

  def add_content(slide, []), do: slide
  def add_content(slide, [item|rest_items]) do 
    add_content(add_content(slide, item), rest_items)
  end
  def add_content(slide, string) when is_binary(string) do
    add_content(slide, Presentir.Paragraph.new(string)) 
  end
  def add_content(slide, item), do: %{slide | content: slide.content ++ [item]}

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