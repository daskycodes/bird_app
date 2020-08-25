defmodule BirdAppUiWeb.MessageComponent do
  use BirdAppUiWeb, :live_component

   @defaults %{
    message: {"Loading...", %{message: "Loading..."}},
    cursor: "",
    click_action: ""
  }

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, Map.merge(@defaults, assigns))}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="bg-white shadow rounded px-8 pt-6 pb-8 mb-4 flex flex-row items-center">
      <div class="flex-1">
        <p class="w-full py-2 break-words"/><%= elem(@message, 1).message %></p>
        <div class="text-sm">
          <p class="text-gray-900 leading-none">Anonymous</p>
          <p class="text-gray-600"><%= elem(@message, 0) %></p>
        </div>
      </div>
      <div class="flex-shrink pl-4">
        <img class="rounded h-24 <%= @cursor %>"
              src="<%= Routes.snap_path(BirdAppUiWeb.Endpoint, :image, elem(@message, 0)) %>"
              alt="Camera Snapshot"
              phx-click="<%= @click_action %>"
              phx-value-key="<%= elem(@message, 0) %>"
        />
      </div>
    </div>
    """
  end
end
