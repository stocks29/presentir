defmodule Presentir.Pre do
  defstruct content: ""

  def new(content), do: %Presentir.Pre{content: content}

  defimpl Presentir.Render, for: Presentir.Pre do
    def as_text(pre), do: pre.content
  end
end