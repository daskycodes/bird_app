
defmodule BirdAppUiWeb.SnapCountComponent do
  use BirdAppUiWeb, :live_component

  alias BirdAppUi.DB

  @impl true
  def mount(socket) do
    if connected?(socket), do: DB.subscribe()

    {:ok, assign(socket, :snaps, DB.entries())}
  end

  @impl true
  def update(_assigns, socket) do
    {:ok, assign(socket, :snaps, DB.entries())}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="w-full md:w-1/3 p-3">
      <div class="rounded shadow-lg p-2">
          <div class="flex flex-row items-center">
              <div class="flex-shrink pr-4">
                  <div class="rounded p-3 bg-green-600"><i class="fa fa-crow fa-2x fa-fw fa-inverse"></i></div>
              </div>
              <div class="flex-1 text-right md:text-center">
                  <h5 class="font-bold uppercase text-gray-400">Birds snapped</h5>
                  <h3 class="font-bold text-3xl text-gray-600"><% @snaps %></h3>
              </div>
          </div>
      </div>
    </div>
    """
  end

end
