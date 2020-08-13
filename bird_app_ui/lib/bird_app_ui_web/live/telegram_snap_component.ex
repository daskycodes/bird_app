defmodule BirdAppUiWeb.TelegramSnapComponent do
  use BirdAppUiWeb, :live_component

  alias BirdAppHardware.Camera

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <button class="w-full font-bold bg-white hover:bg-gray-100 text-gray-800 py-2 px-4 border border-gray-400 rounded shadow my-2" phx-click="snap" phx-target="<%= @myself %>">
      Snap
    </button>
    """
  end

  @impl true
  def handle_event("snap", _, socket) do
    IO.puts("Hi")
    File.write!("/tmp/snap.jpg", Camera.next_frame())
    chat_id = System.get_env("TELEGRAM_CHAT_ID")
    bot_id = System.get_env("TELEGRAM_BOT_ID")
    IO.inspect(bot_id)
    Telegram.Api.request(Application.fetch_env!(:telegram, :bot_token), "sendPhoto", chat_id: Application.fetch_env!(:telegram, :chat_id), photo: {:file, "/tmp/snap.jpg"})
    {:noreply, socket}
  end
end
