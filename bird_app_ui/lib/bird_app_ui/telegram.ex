defmodule BirdAppUi.Telegram do
  alias Telegram.Api

  @token Application.fetch_env!(:telegram, :bot_token)
  @chat Application.fetch_env!(:telegram, :chat_id)

  def send_snap(snap) do
    Api.request(@token, "sendPhoto", chat_id: @chat, photo: {:file_content, snap, "snap.jpg"})
  end

  def send_message(message) do
    Api.request(@token, "sendMessage", chat_id: @chat, text: message, disable_notification: true)
  end

  def chat_url() do
    Application.fetch_env!(:telegram, :chat_url)
  end
end
