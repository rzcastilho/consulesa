defmodule Consulesa.Command.Address do
  use DoIt.Command,
    description: "Manages Consul Addresses"

  subcommand(Consulesa.Command.Address.List)
  subcommand(Consulesa.Command.Address.Add)
  subcommand(Consulesa.Command.Address.Remove)
end
