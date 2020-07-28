defmodule BirdAppUiWeb.ServoSwitchComponent do
  use BirdAppUiWeb, :live_component

  alias BirdAppHardware.Servo

  @impl true
  def mount(socket) do
    if connected?(socket), do: Servo.subscribe()

    {:ok, assign(socket, :pulsewidth, Servo.state())}
  end

  @impl true
  def update(_assigns, socket) do
    {:ok, assign(socket, :pulsewidth, Servo.state())}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <button phx-click="switch-pulsewidth" phx-target="<%= @myself %>">
      Pulsewidth is <%= @pulsewidth %>
    </button>
    """
  end

  @impl true
  def handle_event("switch-pulsewidth", _, socket) do
    Servo.switch_pulsewidth()

    socket = assign(socket, :pulsewidth, Servo.state())
    {:noreply, socket}
  end
end
