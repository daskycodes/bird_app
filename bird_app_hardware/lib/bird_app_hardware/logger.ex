defmodule BirdAppHardware.Logger do
  require Logger

  def handle_event(event, measurements, metadata, _config) do
    Logger.info("Event: #{inspect(event)}")
    Logger.info("Measurements: #{inspect(measurements)}")
    Logger.info("Metadata: #{inspect(metadata)}")
  end
end
