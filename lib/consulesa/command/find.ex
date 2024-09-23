defmodule Consulesa.Command.Find do
  alias Consulesa.Http.ConsulClient

  use DoIt.Command,
    description: "Finds key/value at Consul"

  argument(:consul, :string, "consul address name")

  option(:key, :string, "search key")
  option(:value, :string, "search value")

  def run(_, %{key: _key, value: _value}, _) do
    IO.puts("Please, inform the key or value options, not both!")
  end

  def run(%{consul: consul}, %{key: _key} = search, %{config: %{"addresses" => addresses}}) do
    perform(consul, addresses, search)
  end

  def run(%{consul: consul}, %{value: _value} = search, %{config: %{"addresses" => addresses}}) do
    perform(consul, addresses, search)
  end

  def run(_, _, _) do
    IO.puts("Invalid params!")
  end

  defp perform(consul, addresses, search) do
    consul
    |> validate_address(addresses)
    |> ConsulClient.client()
    |> ConsulClient.get_kv()
    |> Enum.filter(&non_nil_value/1)
    |> Enum.map(&parse_entry/1)
    |> Enum.filter(&filter_kv(&1, search))
    |> Enum.map(&highlight_kv(&1, search))
    |> Enum.map(&to_list/1)
    |> TableRex.quick_render!(
      ["Key", "Value"],
      "Consul [#{IO.ANSI.bright()}#{IO.ANSI.red()}#{consul}#{IO.ANSI.reset()}]"
    )
    |> IO.puts()
  end

  defp validate_address(consul, addresses) do
    case Map.fetch(addresses, consul) do
      {:ok, url} ->
        url

      :error ->
        raise "Invalid consul address! Check the consulesa address command."
    end
  end

  defp non_nil_value(%{"Value" => nil}), do: false
  defp non_nil_value(_), do: true

  defp parse_entry(%{"Key" => key, "Value" => value}),
    do: %{key: key, value: Base.decode64!(value)}

  defp filter_kv(%{key: key}, %{key: filter}) do
    String.contains?(key, filter)
  end

  defp filter_kv(%{value: value}, %{value: filter}) do
    String.contains?(value, filter)
  end

  defp highlight_kv(%{key: key} = map, %{key: filter}) do
    Map.put(
      map,
      :key,
      String.replace(
        key,
        filter,
        IO.ANSI.bright() <> IO.ANSI.green() <> filter <> IO.ANSI.reset()
      )
    )
  end

  defp highlight_kv(%{value: value} = map, %{value: filter}) do
    Map.put(
      map,
      :value,
      String.replace(
        value,
        filter,
        IO.ANSI.bright() <> IO.ANSI.green() <> filter <> IO.ANSI.reset()
      )
    )
  end

  defp to_list(%{key: key, value: value}) do
    [key, value]
  end
end
