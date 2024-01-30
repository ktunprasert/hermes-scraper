defmodule Hermes.Scraper do
  alias Hermes.Parser

  def scrape_links(url) do
    {:ok, %{body: body}} =
      Req.get(url)

    Floki.parse_document!(body)
    |> Parser.find_products()
  end
end
