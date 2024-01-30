defmodule Product do
  defstruct [:name, :price, :link, :img]

  def to_airtable_payload(%__MODULE__{} = struct) do
    map = struct |> Map.from_struct()

    %{
      "Name" => map[:name],
      "Price" => map[:price] |> String.replace(~r/\D/, "") |> String.to_integer(),
      "Link" => map[:link],
      "Image" => [
        %{
          "url" => "https:" <> map[:img]
        }
      ]
    }
  end

  def from_map(%{} = map), do: struct(Product, map)
end
