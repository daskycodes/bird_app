defmodule BirdAppUi.Telegram do

  @chat_id Application.get_env(:nadia, :chat_id)

  def send(message, snap) do
    send_message(message)
    send_snap(snap)
  end

  defp send_message(message) do
    Nadia.send_message(@chat_id, message)
  end

  defp send_snap(snap) do
    File.write!("/tmp/snap.jpg", snap)
    Nadia.send_photo(@chat_id, "/tmp/snap.jpg")
  end

  def chat_url() do
    Application.get_env(:nadia, :chat_url)
  end
end
