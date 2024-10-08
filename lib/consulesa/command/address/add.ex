defmodule Consulesa.Command.Address.Add do
  alias DoIt.Commfig

  use DoIt.Command,
    description: "Adds or updates a Consul address"

  argument(:name, :string, "server name")
  argument(:url, :string, "server url")

  def run(%{name: name, url: url}, _, %{config: %{"addresses" => addresses}}) do
    Commfig.set("addresses", Map.put(addresses, name, url))

    case Map.fetch(addresses, name) do
      {:ok, _url} ->
        IO.puts("Address '#{name}' successfully updated! [#{url}]")

      _ ->
        IO.puts("Address '#{name}' successfully added! [#{url}]")
    end
  end

  def run(%{name: name, url: url}, _, _) do
    Commfig.set("addresses", Map.put(%{}, name, url))
    IO.puts("Address '#{name}' successfully added! [#{url}]")
  end
end
