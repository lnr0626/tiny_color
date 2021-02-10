defmodule TinyColor.HSV do
  @moduledoc """
  Represents a color in the for of red, green, blue, and optional alpha
  """
  defstruct hue: 0.0, saturation: 0.0, value: 0.0, alpha: 1.0

  import TinyColor.Normalize

  @doc ~S"""
  Returns a string representation of this color. hex is only supported if alpha == 1.0

  ## Examples

      iex> TinyColor.HSV.to_string(%TinyColor.HSV{hue: 128.0, saturation: 47.0, value: 50.0})
      "hsv(128, 47%, 50%)"

      iex> TinyColor.HSV.to_string(%TinyColor.HSV{hue: 128.0, saturation: 47.0, value: 50.0, alpha: 0.5})
      "hsva(128, 47%, 50%, 0.5)"

      iex> TinyColor.HSV.to_string(%TinyColor.HSV{hue: 128.0, saturation: 47.0, value: 50.0}, :hsva)
      "hsva(128, 47%, 50%, 1.0)"

      iex> TinyColor.HSV.to_string(%TinyColor.HSV{hue: 128.0, saturation: 47.0, value: 50.0, alpha: 0.5}, :hsva)
      "hsva(128, 47%, 50%, 0.5)"

  """
  def to_string(struct, type \\ nil)

  def to_string(%__MODULE__{hue: h, saturation: s, value: v, alpha: alpha}, :hsva) do
    "hsva(#{round(h)}, #{round(s)}%, #{round(v)}%, #{Float.round(alpha, 4)})"
  end

  def to_string(%__MODULE__{hue: h, saturation: s, value: v, alpha: 1.0}, _) do
    "hsv(#{round(h)}, #{round(s)}%, #{round(v)}%)"
  end

  def to_string(%__MODULE__{} = struct, _) do
    to_string(struct, :hsva)
  end

  def new(hue, saturation, value, alpha \\ 1.0) do
    %__MODULE__{
      hue: cast(hue, :hue),
      saturation: cast(saturation, :saturation),
      value: cast(value, :value),
      alpha: cast(alpha, :alpha)
    }
  end

  def percentages(%TinyColor.HSV{hue: h, saturation: s, value: v, alpha: a}) do
    {
      h / 360,
      s / 100,
      v / 100,
      a
    }
  end

  defimpl String.Chars do
    def to_string(struct) do
      TinyColor.HSV.to_string(struct)
    end
  end

  defimpl Jason.Encoder do
    def encode(value, opts) do
      Jason.Encode.string(TinyColor.HSV.to_string(value), opts)
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(value), do: to_string(value)
  end
end
