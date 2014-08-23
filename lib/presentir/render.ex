defprotocol Presentir.Render do
  @doc "Returns the rendered representation of the presentation component"
  def as_text(component)
end

defimpl Presentir.Render, for: List do
  def as_text(list) do
    as_text(list, "")
  end

  defp as_text([], acc), do: acc
  defp as_text([head|tail], acc) do
    as_text(tail, acc <> Presentir.Render.as_text(head) <> "\n")
  end
end

defimpl Presentir.Render, for: BitString do
  def as_text(string) do
    string
  end
end