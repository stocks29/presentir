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
    def as_text(presentation) do
      "#{presentation.name}\n\nby #{presentation.author}" 
    end
  end
end