defmodule BirdAppFirmwareTest do
  use ExUnit.Case
  doctest BirdAppFirmware

  test "greets the world" do
    assert BirdAppFirmware.hello() == :world
  end
end
