defmodule Presentir.Pre do
  defstruct content: ""

  def new(content), do: %Presentir.Pre{content: content}
  def content(pre), do: pre.content

  defimpl Presentir.Render, for: Presentir.Pre do
    alias Presentir.Pre, as: Pre
    def as_text(pre), do: Pre.content(pre)
    def as_html(pre), do: "<pre class=\"presentir-pre\">#{Pre.content(pre)}</pre>"
  end
end