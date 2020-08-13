
defmodule BirdAppUiWeb.HumidityComponent do
  use BirdAppUiWeb, :live_component

  alias BirdAppHardware.Dht

  @impl true
  def mount(socket) do
    if connected?(socket), do: Dht.subscribe()

    {:ok, assign(socket, :humidity, "Loading...")}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, :humidity, assigns.humidity)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="w-full md:w-1/3 p-3">
      <div class="rounded shadow-lg p-2">
          <div class="flex flex-row items-center">
              <div class="flex-shrink pr-4">
                  <div class="rounded p-3 bg-blue-600"><i class="fa fa-tint fa-2x fa-fw fa-inverse"></i></div>
              </div>
              <div class="flex-1 text-right md:text-center">
                  <h5 class="font-bold uppercase text-gray-400">Humidity</h5>
                  <h3 class="font-bold text-3xl text-gray-600"><%= @humidity %>%</h3>
              </div>
          </div>
      </div>
    </div>
    """
  end

end
