defmodule Consulesa.Command.Address.Add do
  alias DoIt.Commfig

  use DoIt.Command,
    description: "Adds a new Consul address"

  argument(:name, :string, "server name")
  argument(:url, :string, "server url")

  def run(%{name: name, url: url}, _, %{config: %{"addresses" => addresses}}) do
    Commfig.set("addresses", Map.put(addresses, name, url))
  end

  def run(%{name: name, url: url}, _, _) do
    Commfig.set("addresses", Map.put(%{}, name, url))
  end
end
