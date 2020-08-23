defmodule BirdAppUiWeb.SnapController do
  use BirdAppUiWeb, :controller

  def image(conn, %{"key" => key}) do
    entry = BirdAppUi.DB.get_entry(key)

    conn
    |> put_resp_header("Age", "0")
    |> put_resp_header("Cache-Control", "no-cache, private")
    |> put_resp_header("Pragma", "no-cache")
    |> put_resp_header("Content-Type", "image/jpeg")
    |> send_resp(200, entry.snap)
  end
end
