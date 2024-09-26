defmodule Consulesa.Command.Find do
  alias Consulesa.Http.ConsulClient

  alias Consulesa.Helpers.{
    FilterAndTransform,
    Table
  }

  use DoIt.Command,
    description: "Finds key/value at Consul"

  argument(:consul, :string, "consul address name")
  argument(:find, :string, "text to find")

  option(:target, :string, "find target",
    alias: :t,
    default: "value",
    allowed_values: ["key", "value"]
  )

  def run(%{consul: consul, find: find}, %{target: target}, %{
        config: %{"addresses" => addresses}
      }) do
    perform(consul, find, target, addresses)
  end

  defp perform(consul, find, target, addresses) do
    case Map.fetch(addresses, consul) do
      {:ok, url} ->
        url
        |> ConsulClient.client()
        |> ConsulClient.get_kv()
        |> Enum.map(&FilterAndTransform.parse_entry/1)
        |> Enum.filter(&FilterAndTransform.non_nil_value?/1)
        |> Enum.filter(&FilterAndTransform.contains?(&1, find, target))
        |> Table.print_find_table(find, target, consul, url)

      :error ->
        IO.puts("Consul address '#{consul}' not found! Check the consulesa address list command.")
    end
  end
end
