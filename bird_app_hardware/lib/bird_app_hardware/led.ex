defmodule BirdAppHardware.Led do
  require Logger

  alias Circuits.GPIO

  @output_pin Application.get_env(:bird_app_hardware, :output_pin, 18)

  def switch_power() do
    case state() do
      "off" -> GPIO.write(output_gpio, 1)
      "on" -> GPIO.write(output_gpio, 0)
    end
  end

  def state() do
    case GPIO.read(output_gpio) do
      0 -> "off"
      1 -> "on"
    end
  end

  def output_gpio() do
    {:ok, output_gpio} = GPIO.open(@output_pin, :output)
    output_gpio
  end
end
