defmodule BirdAppUiWeb.TelegramSnapComponent do
  use BirdAppUiWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :message, "")}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <form class="bg-white shadow rounded px-8 pt-6 pb-8 mb-4" phx-submit="snap" phx-target="<%= @myself %>">
      <fieldset>
        <label class="block text-gray-700 text-sm font-bold mb-2" for="nameField">Message</label>
        <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="text" name="message" value="<%= @message %>" placeholder="Pigeons are fightin!" autofocus autocomplete="off" minlength="2" maxlength="100"/>
        <input class="w-full font-bold bg-white hover:bg-gray-100 text-gray-800 py-2 px-4 rounded shadow my-2" type="submit" value="Send Snap">
      </fieldset>
    </form>
    """
  end

  @impl true
  def handle_event("snap", %{"message" => message}, socket) do
    case String.length(message) do
      n when n < 2 ->
        {:noreply,
         socket |> put_flash(:error, "Message must be greater than 2") |> push_redirect(to: "/")}

      n when n > 100 ->
        {:noreply,
         socket |> put_flash(:error, "Message must be smaller than 100") |> push_redirect(to: "/")}

      n ->
        snap = BirdAppHardware.Camera.next_frame()
        BirdAppUi.DB.put_entry(message)
        BirdAppUi.Telegram.send_snap(snap)

        {:noreply, socket |> put_flash(:info, "Message sent") |> push_redirect(to: "/")}
    end
  end
end
