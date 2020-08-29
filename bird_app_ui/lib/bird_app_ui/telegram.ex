defmodule BirdAppUi.Telegram do

  @token Application.fetch_env!(:nadia, :token)
  @chat_id Application.fetch_env!(:nadia, :chat_id)

  def send_snap(snap) do
    File.write!("/tmp/snap.jpg", snap)
    Nadia.send_photo(@chat_id, "/tmp/snap.jpg")
  end

  def send_message(message) do
    Nadia.send_message(@chat_id, message)
  end

  def chat_url() do
    Application.fetch_env!(:nadia, :chat_url)
  end
end
