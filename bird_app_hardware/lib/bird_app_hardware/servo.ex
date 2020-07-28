defmodule BirdAppHardware.Servo do
  require Logger

  alias Pigpiox.GPIO

  def switch_pulsewidth() do
    case state() do
      1000 -> GPIO.set_servo_pulsewidth(23, 2000)
      2000 -> GPIO.set_servo_pulsewidth(23, 1000)
      _ -> GPIO.set_servo_pulsewidth(23, 1000)
    end
    broadcast(:ok, :pulsewidth_switched)
    :ok
  end

  def state() do
    case GPIO.get_servo_pulsewidth(23) do
      {:ok, state} -> state
      {:error, message} -> message
    end
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(BirdAppUi.PubSub, "direction_switched")
  end

  def broadcast(:ok, event) do
    Phoenix.PubSub.broadcast(BirdAppUi.PubSub, "direction_switched", {event, state()})
    {:ok, state()}
  end
end
