defmodule Consulesa.Command.Address.Remove do
  alias DoIt.Commfig

  use DoIt.Command,
    description: "Removes a Consul address"

  argument(:name, :string, "server name")

  def run(%{name: name}, _, %{config: %{"addresses" => addresses}}) do
    case Map.fetch(addresses, name) do
      {:ok, url} ->
        Commfig.unset(["addresses", name])
        IO.puts("Address '#{name}' successfully removed! [#{url}]")

      :error ->
        IO.puts("Address '#{name}' not found!")
    end
  end
end
