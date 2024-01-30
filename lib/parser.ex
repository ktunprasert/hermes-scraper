defmodule Hermes.Parser do
  def find_products(html) do
    for card <- html |> Floki.find(".product-grid-list-item") do
      %{
        name: card |> Floki.find(".product-item-name") |> Floki.text(),
        price: card |> Floki.find(".price") |> Floki.text() |> String.trim(),
        link: card |> Floki.find("a") |> Floki.attribute("href") |> then(& "https://hermes.com#{&1}"),
        img: card |> Floki.find("img") |> Floki.attribute("src") |> hd
      }
    end
  end
end
