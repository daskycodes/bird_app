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

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params) do
    assign(socket, show_modal: false)
  end

  def apply_action(socket, :modal, params) do
    assign(socket, show_modal: true, key: Map.get(params, "key"))
  end

  def apply_action(socket, _live_action, _params) do
    push_patch(socket,
      to: Routes.snap_history_path(socket, :index),
      replace: true
    )
  end

  def handle_event("open-modal", %{"key" => key}, socket) do
    {:noreply,
     socket
     |> assign(:key, key)
     |> push_patch(
       to: Routes.snap_history_path(socket, :modal, key),
       replace: true
     )}
  end

  def handle_info(
        {BirdAppUiWeb.ModalComponent, :button_clicked, %{action: "close"}},
        socket
      ) do
    {:noreply,
     push_patch(socket,
       to: Routes.snap_history_path(socket, :index),
       replace: true
     )}
  end
end
