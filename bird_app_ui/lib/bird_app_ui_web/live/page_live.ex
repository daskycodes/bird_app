defmodule BirdAppUiWeb.PageLive do
  use BirdAppUiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    measurements = BirdAppHardware.Dht.read(Dht4)
    {:ok, assign(socket, temperature: measurements.temperature, humidity: measurements.humidity)}
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
    send_update(BirdAppUiWeb.HumidityComponent, [id: "humidity", humidity: measurements.humidity])
    send_update(BirdAppUiWeb.TemperatureComponent, [id: "temperature", temperature: measurements.temperature])
    {:noreply, socket}
  end
end
