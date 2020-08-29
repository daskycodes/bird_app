defmodule BirdAppUiWeb.SnapController do
  use BirdAppUiWeb, :controller

  def snap(conn, %{"key" => key}) do
    entry = BirdAppUi.DB.get_entry(key)

    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, entry.snap)
  end

  def current_snap(conn, _params) do
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, BirdAppHardware.Camera.next_frame())
  end
end
