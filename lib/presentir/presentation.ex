defmodule Presentir.Presentation do
  defstruct name: "Unamed Presentation", author: "Nobody", slides: []

  def new(name, author, slides \\ []) do
    %Presentir.Presentation{name: name, author: author, slides: slides} 
  end

  def add_slide(presentation, slide) do
    new_slides = presentation.slides ++ slide
    %{presentation | slides: new_slides}
  end

  def slides(presentation) do
    presentation.slides
  end

  defimpl Presentir.Render, for: Presentir.Presentation do
    def as_text(presentation) do
      "#{presentation.name}\n\nby #{presentation.author}" 
    end
  end
end