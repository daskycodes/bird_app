defmodule BirdAppUiWeb.StatsComponent do
  use BirdAppUiWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="w-full md:w-1/3 p-3">
      <div class="rounded shadow-lg p-2">
          <div class="flex flex-row items-center">
              <div class="flex-shrink pr-4">
                  <div class="rounded p-3 bg-<%= @color %>-600"><i class="fa <%= @icon %> fa-2x fa-fw fa-inverse"></i></div>
              </div>
              <div class="flex-1 text-right md:text-center">
                  <h5 class="font-bold uppercase text-gray-400"><%= @stats_name %></h5>
                  <h3 class="font-bold text-3xl text-gray-600"><%= @stats %><%= @character %></h3>
              </div>
          </div>
      </div>
    </div>
    """
  end
end
