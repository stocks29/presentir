defmodule Presentir.Slide do
  defstruct title: "Untitled Slide", content: []

  def new(title, content \\ []) do
    %Presentir.Slide{title: title} |> add_content(content)
  end

  def title(slide), do: slide.title
  def content(slide), do: slide.content

  def add_content(slide, []), do: slide
  def add_content(slide, [item|rest_items]) do 
    add_content(add_content(slide, item), rest_items)
  end
  def add_content(slide, string) when is_binary(string) do
    add_content(slide, Presentir.Paragraph.new(string)) 
  end
  def add_content(slide, item), do: %{slide | content: content(slide) ++ [item]}

  defimpl Presentir.Render, for: Presentir.Slide do
    alias Presentir.Slide, as: S

    def as_text(slide) do
      underline = underline(S.title(slide), "-")
      content = Presentir.Render.as_text(S.content(slide))
      "\n#{slide.title}\n#{underline}\n\n#{content}\n" 
    end

    def as_html(slide) do
      "<section class=\"presentir-slide\"><h1 class=\"presentir-title\">#{slide.title}</h1>" <> Presentir.Render.as_html(S.content(slide)) <> "</section>"
    end

    defp underline(str, char) do
      Enum.map(String.to_char_list(str), fn(_) -> char end)
    end
  end

end