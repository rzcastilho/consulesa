defmodule Consulesa.Command.Replace do
  alias Consulesa.Http.ConsulClient

  alias Consulesa.Helpers.{
    FilterAndTransform,
    Table,
    TextHighlight
  }

  use DoIt.Command,
    description: "Replaces values at Consul"

  @gray IO.ANSI.color(2, 2, 2)

  @no ["", "n", "no"]
  @yes ["y", "yes"]

  argument(:consul, :string, "consul address name")
  argument(:find, :string, "text to find")
  argument(:replace, :string, "text to replace")

  def run(%{consul: consul, find: find, replace: replace}, _opts, %{
        config: %{"addresses" => addresses}
      }) do
    perform(consul, find, replace, addresses)
  end

  defp perform(consul, find, replace, addresses) do
    case Map.fetch(addresses, consul) do
      {:ok, url} ->
        url
        |> ConsulClient.client()
        |> ConsulClient.get_kv()
        |> Enum.map(&FilterAndTransform.parse_entry/1)
        |> Enum.filter(&FilterAndTransform.non_nil_value?/1)
        |> Enum.filter(&FilterAndTransform.contains?(&1, find))
        |> Enum.map(&FilterAndTransform.map_new_value(&1, find, replace))
        |> Table.print_replace_table(find, replace, consul, url)
        |> Enum.each(&confirm_replace(&1, url))

      :error ->
        IO.puts("Consul address '#{consul}' not found! Check the consulesa address list command.")
    end
  end

  defp confirm_replace(%{"key" => key, "new_value" => new_value} = entry, url) do
    case ask(entry) do
      resp when resp in @no ->
        "SKIPPED!\n"
        |> TextHighlight.highlight([:bright, @gray])
        |> IO.puts()

      resp when resp in @yes ->
        url
        |> ConsulClient.client()
        |> ConsulClient.put_kv(key, new_value)

        "REPLACED!\n"
        |> TextHighlight.highlight([:bright, :green])
        |> IO.puts()

      _ ->
        "Wrong answer! Try again...\n"
        |> TextHighlight.highlight([:bright, :red])
        |> IO.puts()

        confirm_replace(entry, url)
    end
  end

  defp ask(%{
         "key" => key,
         "value" => value,
         "find" => find,
         "replace" => replace
       }) do
    """
    #{TextHighlight.highlight(key, [:bright])}
    - Current: #{TextHighlight.highlight(value, find, [:bright, :red])}
    - New: #{TextHighlight.highlight(value, find, replace, [:bright, :green])}
    Are you sure you'd like to replace values? (y/N)
    """
    |> String.trim()
    |> IO.gets()
    |> String.trim()
    |> String.downcase()
  end
end
