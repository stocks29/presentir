defmodule Presentir.UnorderedListItem do
  defstruct content: ""

  defimpl Presentir.Render, for: Presentir.UnorderedListItem do
    def as_text(li), do: render_lines(li) |> format_lines() |> Enum.reverse() |> Enum.join("\n")

    defp render_lines(li), do: Presentir.Render.as_text(li.content) |> String.split("\n")

    defp format_lines(lines), do: format_lines(lines, [])

    defp format_lines([], acc), do: acc
    defp format_lines([line|more_lines], []), do: format_lines(more_lines, ["* #{line}"])
    defp format_lines([line|more_lines], acc), do: format_lines(more_lines, ["  #{line}"|acc])
  end
end

defmodule Presentir.UnorderedList do
  defstruct items: []

  def new(items \\ []), do: add_items(%Presentir.UnorderedList{}, items)

  def add_items(ul, []), do: ul
  def add_items(ul, [item|rest_items]), do: add_items(add_item(ul, item), rest_items)

  def add_item(ul, string) when is_binary(string) do
    add_item(ul, %Presentir.UnorderedListItem{content: string}) 
  end
  def add_item(ul, item), do: %{ul | items: ul.items ++ [item]}

  defimpl Presentir.Render, for: Presentir.UnorderedList do
    def as_text(ul), do: as_text(ul.items, "")

    defp as_text([], acc), do: acc
    defp as_text([item|more_items], acc) do
      rendered = rendered_lines(item)
      |> indent_lines(4)
      |> Enum.join("\n")
      as_text(more_items, append_line(acc, rendered))
    end

    defp append_line(base, ""), do: base
    defp append_line("", more), do: more 
    defp append_line(base, more), do: base <> "\n\n" <> more

    defp indent_lines(lines, space_count) do
      indentation = spaces(space_count)
      Enum.map(lines, fn (line) -> indentation <> line end)
    end

    defp spaces(count), do: Enum.reduce(1..count, "", fn (_elem, acc) -> " " <> acc end)

    defp rendered_lines(component), do: String.split(Presentir.Render.as_text(component), "\n")
  end
end