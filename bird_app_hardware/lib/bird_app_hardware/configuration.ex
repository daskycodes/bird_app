defmodule BirdAppHardware.Configuration do
  defstruct size: %{width: 640, height: 480},
            img_effect: :normal

  @typedoc @moduledoc
  @type t ::
          %__MODULE__{
            size: dimensions(),
            img_effect: img_effect()
          }

  @type dimensions ::
          %{width: non_neg_integer(), height: non_neg_integer()}

  @type img_effect ::
          :normal
          | :sketch
          | :oilpaint
end
