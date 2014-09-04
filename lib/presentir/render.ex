defprotocol Presentir.Render do
  @doc "Returns the rendered representation of the presentation component"
  def as_text(component)
  def as_html(component)
end

defimpl Presentir.Render, for: List do
  def as_text(list), do: as_text(list, "")
  def as_html(list), do: as_html(list, "")

  defp as_text([], acc), do: acc
  defp as_text([head|tail], acc) do
    as_text(tail, acc <> Presentir.Render.as_text(head) <> "\n")
  end

  defp as_html([], acc), do: acc
  defp as_html([head|tail], acc) do
    rendered = Presentir.Render.as_html(head)
    as_html(tail, acc <> "#{rendered}\n") 
  end
end

defimpl Presentir.Render, for: BitString do
  def as_text(string) do
    tokens(string)
    |> combine_tokens(80)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  def as_html(string), do: string

  defp tokens(string) do
    String.split(string)
  end

  defp combine_tokens(tokens, length) do
    combine_tokens(tokens, length, "", [])
  end

  defp combine_tokens([], _length, "", acc) do
    acc
  end
  defp combine_tokens([], _length, current_line, acc) do
    [current_line|acc]
  end
  defp combine_tokens([token|more_tokens], length, "", acc) do
    combine_tokens(more_tokens, length, token, acc)
  end
  defp combine_tokens([token|more_tokens], length, current_line, acc) when byte_size(token) + byte_size(current_line) >= length do
    combine_tokens([token|more_tokens], length, "", [current_line|acc])
  end
  defp combine_tokens([token|more_tokens], length, current_line, acc) do
    combine_tokens(more_tokens, length, append(current_line, token), acc) 
  end

  defp append("", token) do
    token
  end
  defp append(current_line, token) do
    current_line <> " " <> token
  end
end