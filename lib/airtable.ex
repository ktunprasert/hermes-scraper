defmodule Hermes.Airtable do
  @app_id "appRk9ZG9xWWbhlgk"
  @table_id "tbl5zwlCM3z22G2UM"

  @url "https://api.airtable.com/v0/#{@app_id}/#{@table_id}/"
  @auth_token System.get_env("AIRTABLE_TOKEN")

  def create_record(payload) do
    %{status: status, body: body} =
      Req.post!(
        @url,
        json: payload,
        headers: headers()
      )

    %{status_code: status, body: body}
  end

  def create_records(payload) do
    %{
      status: status,
      body: body
    } =
      Req.patch!(
        @url,
        json: %{
          "performUpsert" => %{
            "fieldsToMergeOn" => ["Link"]
          },
          "records" => payload
        },
        headers: headers()
      )

    %{status_code: status, body: body}
  end

  def list_ids() do
    %{body: body} =
      Req.get!(
        @url <> "?fields[]=URL",
        headers: headers()
      )

    body
    |> Jason.decode!()
    |> Map.get("records")
    |> Enum.map(&get_in(&1, ["fields", "URL"]))
  end

  defp headers() do
    [
      {"Authorization", "Bearer #{@auth_token}"},
      {"Content-Type", "application/json"}
    ]
  end
end
