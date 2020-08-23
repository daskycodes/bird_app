defmodule BirdAppUi.Telegram do
  alias Telegram.Api

  def send_snap(snap) do
    Api.request(Application.fetch_env!(:telegram, :bot_token), "sendPhoto",
      chat_id: Application.fetch_env!(:telegram, :chat_id),
      photo: {:file_content, snap, "snap.jpg"}
    )
  end

  def chat_url() do
    Application.fetch_env!(:telegram, :chat_url)
  end
end
