defmodule Presentir.Presentation do
  defstruct name: "Unamed Presentation", author: "Nobody", description: "", slides: []

  def new(name, author, description \\ "", slides \\ []) do
    %Presentir.Presentation{name: name, author: author, description: description, slides: slides} 
  end

  def add_slide(presentation, slide) do
    new_slides = presentation.slides ++ slide
    %{presentation | slides: new_slides}
  end

  def slides(presentation) do
    [title_slide(presentation)|presentation.slides]
  end

  def title_slide(presentation) do
    present_date = Timex.DateFormat.format!(Timex.Date.local, "%A, %B %e %Y", :strftime)
    Presentir.Slide.new(presentation.name, [
      presentation.description,
      "presented #{present_date} by #{presentation.author}"
      ]) 
  end
  
  defimpl Presentir.Render, for: Presentir.Presentation do
    def as_text(presentation), do: render(presentation, text_join, &Presentir.Render.as_text/1)
    def as_html(presentation), do: render(presentation, html_join, &Presentir.Render.as_html/1)

    defp render(presentation = %Presentir.Presentation{}, join_string, renderer) do 
      render presentation.slides, join_string, renderer
    end

    defp render([], _join_string, _renderer), do: ""
    defp render(items, join_string, renderer) when is_list(items) do
      Enum.map(items, renderer) |> Enum.join(join_string)
    end

    defp html_join, do: "\n<hr>\n"
    defp text_join, do: "\n\n==================================================\n\n"
  end
end