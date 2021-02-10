defmodule TinyColor.Normalize do
  def cast({value, :percent}, field) when field in [:red, :green, :blue] do
    cast(255 * value, field)
  end

  def cast(value, field) when field in [:red, :green, :blue] do
    (value / 1)
    |> min(255.0)
    |> max(0.0)
  end

  def cast({value, :percent}, field) when field in [:saturation, :lightness, :value] do
    cast(value, field)
  end

  def cast(value, field) when field in [:saturation, :lightness, :value] do
    (100 * value / 1)
    |> min(100.0)
    |> max(0.0)
  end

  def cast({value, :percent}, :hue) do
    cast(360 * value, :hue)
  end

  def cast(value, :hue) when is_integer(value) do
    rem(rem(value, 360) + 360, 360) / 1
  end

  def cast(value, :hue) when is_float(value) do
    floored = Kernel.trunc(Float.floor(value))
    fractional = value - floored

    rem(rem(floored, 360) + 360, 360) + fractional
  end

  def cast({value, :percent}, :alpha) do
    cast(value, :alpha)
  end

  def cast(value, :alpha) do
    (value / 1)
    |> min(1.0)
    |> max(0.0)
  end
end
