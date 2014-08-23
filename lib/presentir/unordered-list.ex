defmodule Presentir.UnorderedList do
  defstruct items: []

  def new(items \\ []) do
    %Presentir.UnorderedList{items: items}
  end

  def add_item(ul, item) do
    %{ul | items: ul.items ++ item}
  end

  defimpl Presentir.Render, for: Presentir.UnorderedList do
    def as_text(ul) do
      as_text(ul.items, "") <> "\n" 
    end

    defp as_text([], acc), do: acc
    defp as_text([head|tail], acc) do
      as_text(tail, acc <> "\n    * " <> Presentir.Render.as_text(head))
    end
  end
end