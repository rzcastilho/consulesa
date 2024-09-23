defmodule Consulesa do
  use DoIt.MainCommand,
    description: "CLI that helps to find and replace key/value pairs at Consul"

  command(Consulesa.Command.Address)
  command(Consulesa.Command.Find)
  command(Consulesa.Command.Replace)
end
