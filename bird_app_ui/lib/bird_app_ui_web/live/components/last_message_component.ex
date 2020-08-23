defmodule BirdAppUiWeb.LastMessageComponent do
  use BirdAppUiWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :message, {"Loading...", %{message: "Loading..."}})}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, :message, assigns.message)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="bg-white shadow rounded px-8 pt-6 pb-8 mb-4">
      <label class="block text-gray-700 text-sm font-bold mb-2">Last Message</label>
      <p class="w-full py-2 break-all"/><%= elem(@message, 1).message %></p>
      <div class="text-sm">
        <p class="text-gray-900 leading-none">Anonymous</p>
        <p class="text-gray-600"><%= elem(@message, 0) %></p>
      </div>
      <a href="<%= BirdAppUi.Telegram.chat_url() %>" class="block text-blue-600 text-sm font-bold mt-2">Join the telegram chat now!</a>
    </div>
    """
  end
end
