defmodule BirdAppUiWeb.MessageComponent do
  use BirdAppUiWeb, :live_component

  @defaults %{
    message: {"Loading...", %{message: "Loading..."}},
    cursor: "",
    click_action: "",
    page: nil
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
        <%= if @id == "last-message" do %>
          <label class="block text-gray-700 text-sm font-bold mb-2">Last Message</label>
        <% end %>
        <p class="w-full py-2 break-words"/><%= elem(@message, 1).message %></p>
        <div class="text-sm">
          <p class="text-gray-900 leading-none">Anonymous</p>
          <p class="text-gray-600"><%= elem(@message, 0) %></p>
          <p class="text-orange-600">Temperature: <%= elem(@message, 1).temperature %>°C</p>
          <p class="text-blue-600">Humidity: <%= elem(@message, 1).humidity %>%</p>
        </div>
      </div>
      <div class="flex-shrink pl-4">
        <img class="rounded h-24 <%= @cursor %>"
              src="<%= Routes.snap_path(BirdAppUiWeb.Endpoint, :snap, elem(@message, 0)) %>"
              alt="Camera Snapshot"
              phx-click="<%= @click_action %>"
              phx-value-key="<%= elem(@message, 0) %>"
              phx-value-page="<%= @page %>"
        />
      </div>
    </div>
    """
  end
end
