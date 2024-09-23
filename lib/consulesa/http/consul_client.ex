defmodule Consulesa.Http.ConsulClient do
  def client(base_url) do
    [
      base_url: base_url
    ]
    |> Req.new()
  end

  def get_kv(client, key \\ "", recurse \\ true) do
    case Req.get!(client, url: "/v1/kv/#{key}?recurse=#{recurse}") do
      %{body: body, status: 200} -> body
      _ -> raise "Error fetching KV's from Consul"
    end
  end
end