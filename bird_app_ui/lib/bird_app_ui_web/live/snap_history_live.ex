defmodule BirdAppUiWeb.SnapHistoryLive do
  use BirdAppUiWeb, :live_view
  alias BirdAppUi.DB

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()

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

  @impl true
  def handle_event("open-modal", %{"key" => key}, socket) do
    {:noreply,
     socket
     |> assign(:key, key)
     |> push_patch(
       to: Routes.snap_history_path(socket, :modal, key),
       replace: true
     )}
  end

  @impl true
  def handle_info({:dht_update, measurements}, socket) do
    send_update(BirdAppUiWeb.StatsComponent, id: "humidity", stats: measurements.humidity)
    send_update(BirdAppUiWeb.StatsComponent, id: "temperature", stats: measurements.temperature)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_entry, entries_count, _entries}, socket) do
    send_update(BirdAppUiWeb.StatsComponent, id: "snaps", snaps: entries_count)
    {:noreply, socket}
  end

  @impl true
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

  defp subscribe() do
    BirdAppHardware.Dht.subscribe()
    BirdAppUi.DB.subscribe()
  end
end
