defmodule Consulesa.Helpers.TextHighlight do
  def highlight(value, colors) do
    colors
    |> Kernel.++([value])
    |> IO.ANSI.format()
    |> IO.chardata_to_string()
  end

  def highlight(value, find, colors), do: highlight(value, find, find, colors)

  def highlight(value, find, replace, colors) do
    highlighted_replace =
      colors
      |> Kernel.++([replace])
      |> IO.ANSI.format()
      |> IO.chardata_to_string()

    String.replace(value, find, highlighted_replace)
  end

  def highlight_search([key, value, _new_value], find, replace) do
    [
      key,
      highlight(value, find, [:bright, :red]),
      highlight(value, find, replace, [:bright, :green])
    ]
  end

  def highlight_search([key, value], find, "key") do
    [highlight(key, find, [:bright, :green]), value]
  end

  def highlight_search([key, value], find, "value") do
    [key, highlight(value, find, [:bright, :green])]
  end
end
