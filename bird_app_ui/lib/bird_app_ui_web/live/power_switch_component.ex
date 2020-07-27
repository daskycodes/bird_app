defmodule BirdAppUiWeb.PowerSwitchComponent do
  use BirdAppUiWeb, :live_component

  alias BirdAppHardware.Led

  @impl true
  def mount(socket) do
    if connected?(socket), do: Led.subscribe()

    {:ok, assign(socket, :power, Led.state())}
  end

  def update(_assigns, socket) do
    {:ok, assign(socket, :power, Led.state())}
  end

  def render(assigns) do
    ~L"""
    <button phx-click="switch-power" phx-target="<%= @myself %>">
      Power is <%= @power %>
    </button>
    """
  end

  def handle_event("switch-power", _, socket) do
    Led.switch_power()

    socket = assign(socket, :power, Led.state())
    {:noreply, socket}
  end
end
