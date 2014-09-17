defmodule Presentir.Presentation do
  defstruct name: "Unamed Presentation", author: "Nobody", description: "", slides: []

  def new(name, author, description \\ "", slides \\ []) do
    %Presentir.Presentation{name: name, author: author, description: description, slides: slides} 
  end

  def name(presentation), do: presentation.name
  def author(presentation), do: presentation.author
  def description(presentation), do: presentation.description
  def slides(presentation), do: [title_slide(presentation)|presentation.slides]

  def add_slide(presentation, slide), do: %{presentation | slides: presentation.slides ++ [slide]}

  def title_slide(presentation) do
    Presentir.Slide.new(presentation.name, [
      presentation.description,
      "created by #{presentation.author}",
      "presented #{now}"
      ]) 
  end

  defp now, do: Timex.DateFormat.format!(Timex.Date.local, "%A, %B %e %Y", :strftime)
  
  defimpl Presentir.Render, for: Presentir.Presentation do
    def as_text(presentation), do: render(presentation, text_join, &Presentir.Render.as_text/1)
    def as_html(presentation), do: render(presentation, html_join, &Presentir.Render.as_html/1)

    defp render(presentation = %Presentir.Presentation{}, join_string, renderer) do 
      render Presentir.Presentation.slides(presentation), join_string, renderer
    end

    defp render([], _join_string, _renderer), do: ""
    defp render(items, join_string, renderer) when is_list(items) do
      Enum.map(items, renderer) |> Enum.join(join_string)
    end

    defp html_join, do: "\n<hr>\n"
    defp text_join, do: "\n\n==================================================\n\n"
  end
end