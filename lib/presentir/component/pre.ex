defmodule Presentir.Pre do
  defstruct content: ""

  def new(content), do: %Presentir.Pre{content: content}

  defimpl Presentir.Render, for: Presentir.Pre do
    def as_text(pre), do: pre.content
    def as_html(pre), do: "<pre class=\"presentir-pre\">#{pre.content}</pre>"
  end
end