defmodule Consulesa.Helpers.Table do
  import Consulesa.Helpers.FilterAndTransform, only: [to_row: 1]
  import Consulesa.Helpers.TextHighlight, only: [highlight_search: 3, highlight: 2]

  def print_find_table([], find, target, consul, url) do
    IO.puts("Sorry, the requested #{target} was not found in the Consul KV Store.\n")

    IO.puts("Details:")
    IO.puts("  - Value: #{find}")
    IO.puts("  - Target: #{target}")
    IO.puts("  - Address: #{consul} - #{url}\n")
  end

  def print_find_table(entries, find, target, consul, url) do
    entries
    |> Enum.map(&to_row/1)
    |> Enum.map(&highlight_search(&1, find, target))
    |> TableRex.quick_render!(
      ["Key", "Value"],
      highlight("Consul: [#{consul}](#{url})", [:bright, :yellow])
    )
    |> IO.puts()
  end

  def print_replace_table([], find, replace, consul, url) do
    IO.puts("Sorry, the requested value was not found in the Consul KV Store.\n")

    IO.puts("Details:")
    IO.puts("  - Value: #{find}")
    IO.puts("  - New Value: #{replace}")
    IO.puts("  - Address: #{consul} - #{url}\n")

    []
  end

  def print_replace_table(entries, find, replace, consul, url) do
    entries
    |> Enum.map(&to_row/1)
    |> Enum.map(&highlight_search(&1, find, replace))
    |> TableRex.quick_render!(
      ["Key", "Value", "New Value"],
      highlight("Consul: [#{consul}](#{url})", [:bright, :yellow])
    )
    |> IO.puts()

    entries
  end
end
