defmodule BirdAppUiWeb.SnapHistoryLive do
  use BirdAppUiWeb, :live_view

  alias BirdAppUi.DB

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: DB.subscribe()

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, %{"page" => page}) do
    page = String.to_integer(page)
    assign(socket, show_modal: false, messages: DB.paginate(page), page: page)
  end

  def apply_action(socket, :modal, %{"page" => page, "key" => key}) do
    page = String.to_integer(page)
    assign(socket, show_modal: true, messages: DB.paginate(page), page: page, key: key)
  end

  def apply_action(socket, _live_action, _params) do
    push_patch(socket,
      to: Routes.snap_history_path(socket, :index, 1),
      replace: true
    )
  end

  @impl true
  def handle_event("open-modal", %{"key" => key, "page" => page}, socket) do
    {:noreply,
     socket
     |> assign(:key, key)
     |> push_patch(
       to: Routes.snap_history_path(socket, :modal, page, key),
       replace: true
     )}
  end

  @impl true
  def handle_event("previous", _, socket) do
    page = socket.assigns.page
    {:noreply, push_redirect(socket, to: Routes.snap_history_path(socket, :index, page - 1))}
  end

  @impl true
  def handle_event("next", _, socket) do
    page = socket.assigns.page
    {:noreply, push_redirect(socket, to: Routes.snap_history_path(socket, :index, page + 1))}
  end

  @impl true
  def handle_info({:new_entry, _entries_count, _last_entry}, socket) do
    page = socket.assigns.page
    {:noreply, update(socket, :messages, DB.paginate(page))}
  end

  @impl true
  def handle_info(
        {BirdAppUiWeb.ModalComponent, :button_clicked, %{action: "close", param: page}},
        socket
      ) do
    {:noreply,
     push_patch(socket,
       to: Routes.snap_history_path(socket, :index, page),
       replace: true
     )}
  end
end
