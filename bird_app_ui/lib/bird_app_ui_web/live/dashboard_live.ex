defmodule BirdAppUiWeb.DashboardLive do
  use BirdAppUiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    measurements = BirdAppHardware.Dht.read(Dht4)
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
    send_update(BirdAppUiWeb.HumidityComponent, id: "humidity", humidity: measurements.humidity)

    send_update(BirdAppUiWeb.TemperatureComponent,
      id: "temperature",
      temperature: measurements.temperature
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_entry, entries_count, entries}, socket) do
    send_update(BirdAppUiWeb.SnapCountComponent, id: "snaps", snaps: entries_count)

    send_update(BirdAppUiWeb.LastMessageComponent, id: "last-message", message: entries)

    {:noreply, socket}
  end
end
