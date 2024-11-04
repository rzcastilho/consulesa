defmodule Consulesa.Helpers.FilterAndTransform do
  def parse_entry(%{"Key" => key, "Value" => nil}),
    do: %{"key" => key, "value" => nil}

  def parse_entry(%{"Key" => key, "Value" => value}),
    do: %{"key" => key, "value" => Base.decode64!(value)}

  def non_nil_value?(%{"value" => nil}), do: false
  def non_nil_value?(_), do: true

  def contains?(entry, find, target \\ "value") do
    entry
    |> Map.get(target)
    |> String.contains?(find)
  end

  def map_new_value(entry, find, replace) do
    new_value =
      entry
      |> Map.get("value")
      |> String.replace(find, replace)

    entry
    |> Map.put("new_value", new_value)
    |> Map.put("find", find)
    |> Map.put("replace", replace)
  end

  def to_row(%{"key" => key, "value" => value, "new_value" => new_value}) do
    [key, value, new_value]
  end

  def to_row(%{"key" => key, "value" => value}) do
    [key, value]
  end
end
