defmodule BirdAppHardware.Dht do
  use GenServer
  require Logger

  @dht_pin Application.get_env(:bird_app_hardware, :dht_pin, 4)

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: Dht4)
  end

  def init(_state) do
    Logger.info("Starting DHT Sensor")
    DHT.start_polling(@dht_pin, :dht22, 2)
    state = measurements()
    {:ok, state}
  end

  def read(Dht4) do
    GenServer.call(Dht4, :read)
  end

  def handle_call(:read, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:update, _state) do
    {:noreply, measurements()}
  end

  def handle_event(_event, measurements, _metadata, _config) do
    GenServer.cast(Dht4, :update)

    broadcast(:ok, :dht_update, %{
      humidity: floor(measurements.humidity),
      temperature: floor(measurements.temperature)
    })
  end

  def subscribe do
    Phoenix.PubSub.subscribe(BirdAppUi.PubSub, "dht")
  end

  defp broadcast(:ok, event, data) do
    Phoenix.PubSub.broadcast(BirdAppUi.PubSub, "dht", {event, data})
    {:ok, data}
  end

  defp measurements() do
    case DHT.read(@dht_pin, :dht22) do
      {:ok, measurements} ->
        %{humidity: floor(measurements.humidity), temperature: floor(measurements.temperature)}

      {:error, _message} ->
        measurements()
    end
  end
end
