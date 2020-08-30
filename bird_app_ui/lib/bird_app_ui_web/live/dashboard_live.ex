defmodule BirdAppUiWeb.DashboardLive do
  use BirdAppUiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()

    measurements = BirdAppHardware.Dht.read()
    message = BirdAppUi.DB.last_entry()
    snaps = BirdAppUi.DB.entries_count()

    {:ok,
     assign(socket,
       temperature: measurements.temperature,
       humidity: measurements.humidity,
       message: message,
       snaps: snaps
     )}
  end

  @impl true
  def handle_info({:power_switched, state}, socket) do
    send_update(BirdAppUiWeb.PowerSwitchComponent, id: "power-switch", power: state)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:pulsewidth_switched, state}, socket) do
    send_update(BirdAppUiWeb.ServoSwitchComponent, id: "servo-switch", pulsewidth: state)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:dht_update, measurements}, socket) do
    send_update(BirdAppUiWeb.StatsComponent, id: "humidity", stats: measurements.humidity)
    send_update(BirdAppUiWeb.StatsComponent, id: "temperature", stats: measurements.temperature)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_entry, entries_count, last_entry}, socket) do
    send_update(BirdAppUiWeb.StatsComponent, id: "snaps", stats: entries_count)
    send_update(BirdAppUiWeb.MessageComponent, id: "last-message", message: last_entry)
    {:noreply, socket}
  end

  defp subscribe() do
    BirdAppHardware.Dht.subscribe()
    BirdAppUi.DB.subscribe()
  end
end
