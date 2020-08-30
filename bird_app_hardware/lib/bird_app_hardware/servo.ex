defmodule BirdAppHardware.Servo do
  require Logger

  alias Pigpiox.GPIO

  @servo_pin Application.get_env(:bird_app_hardware, :servo_pin)

  def switch_pulsewidth() do
    if BirdAppHardware.Servo.state() == 1000,
      do:
        GPIO.set_servo_pulsewidth(@servo_pin, 2000)
        |> broadcast(:pulsewidth_switched),
      else:
        GPIO.set_servo_pulsewidth(@servo_pin, 1000)
        |> broadcast(:pulsewidth_switched)
  end

  def state() do
    case GPIO.get_servo_pulsewidth(@servo_pin) do
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
