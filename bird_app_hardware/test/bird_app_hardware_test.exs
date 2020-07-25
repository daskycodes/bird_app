defmodule BirdAppHardwareTest do
  use ExUnit.Case
  doctest BirdAppHardware

  test "greets the world" do
    assert BirdAppHardware.hello() == :world
  end
end
