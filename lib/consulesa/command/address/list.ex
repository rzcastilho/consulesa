defmodule Consulesa.Command.Address.List do
  use DoIt.Command,
    description: "Lists Consul addresses"

  def run(_, _, %{config: %{"addresses" => addresses}}) do
    header = ["name", "url"]

    rows =
      addresses
      |> Map.to_list()
      |> Enum.map(&Tuple.to_list/1)

    TableRex.quick_render!(rows, header)
    |> IO.puts()
  end
end
