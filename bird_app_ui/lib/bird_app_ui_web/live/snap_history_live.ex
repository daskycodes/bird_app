defmodule BirdAppUiWeb.SnapHistoryLive do
  use BirdAppUiWeb, :live_view
  alias BirdAppUi.DB

  @impl true
  def mount(_params, _session, socket) do
    measurements = BirdAppHardware.Dht.read(Dht4)
    snaps = DB.entries_count()
    messages = DB.entries()

    {:ok,
     assign(socket,
       temperature: measurements.temperature,
       humidity: measurements.humidity,
       snaps: snaps,
       messages: messages
     )}
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
end
