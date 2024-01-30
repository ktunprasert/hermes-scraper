defmodule Mix.Tasks.Create.Airtable do
  use Mix.Task

  alias Hermes.{Airtable, Scraper}

  @url "https://www.hermes.com/uk/en/category/women/bags-and-small-leather-goods/bags-and-clutches/#|"

  @impl Mix.Task
  def run(_) do
    Mix.Task.run("app.start")

    IO.puts("Scraping links...")
    products = Scraper.scrape_links(@url)

    payload =
      products
      |> Enum.map(&Product.from_map/1)
      |> Enum.map(&Product.to_airtable_payload/1)
      |> Enum.map(&%{fields: &1})

    IO.puts("Upserting records...")

    payload
    |> Stream.chunk_every(10)
    |> Task.async_stream(&Airtable.create_records/1)
    |> Enum.to_list()
    |> IO.inspect()

    IO.puts("Done!")
  end
end
