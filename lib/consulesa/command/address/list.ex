defmodule Consulesa.Command.Address.List do
  use DoIt.Command,
    description: "Lists Consul addresses"

  @headers ["name", "url"]

  def run(_args, _opts, %{config: %{"addresses" => addresses}}) do
    addresses
    |> Map.to_list()
    |> perform()
  end

  def run(_args, _opts, _ctx), do: perform([])

  defp perform([]), do: IO.puts("There are no registered addresses.")

  defp perform(addresses) do
    rows =
      addresses
      |> Enum.map(&Tuple.to_list/1)

    TableRex.quick_render!(rows, @headers)
    |> IO.puts()
  end
end
