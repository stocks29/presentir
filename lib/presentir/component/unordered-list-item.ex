defmodule Presentir.UnorderedListItem do
  alias Presentir.Render, as: R

  defstruct content: ""

  def new(content \\ ""), do: %Presentir.UnorderedListItem{content: content}
  def content(li), do: li.content

  defimpl Presentir.Render, for: Presentir.UnorderedListItem do
    def as_text(li), do: render_lines(li) |> format_lines() |> Enum.reverse() |> Enum.join("\n")
    def as_html(li), do: "<li>" <> R.as_html(li.content) <> "</li>"

    defp render_lines(li), do: R.as_text(li.content) |> String.split("\n")

    defp format_lines(lines), do: format_lines(lines, [])

    defp format_lines([], acc), do: acc
    defp format_lines([line|more_lines], []), do: format_lines(more_lines, ["* #{line}"])
    defp format_lines([line|more_lines], acc), do: format_lines(more_lines, ["  #{line}"|acc])
  end
end