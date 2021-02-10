defmodule TinyColor.HSL do
  @moduledoc """
  Represents a color in the for of red, green, blue, and optional alpha
  """
  defstruct hue: 0.0, saturation: 0.0, lightness: 0.0, alpha: 1.0

  import TinyColor.Normalize

  @doc ~S"""
  Returns a string representation of this color. hex is only supported if alpha == 1.0

  ## Examples

      iex> TinyColor.HSL.to_string(%TinyColor.HSL{hue: 128.0, saturation: 47.0, lightness: 50.0})
      "hsl(128, 47%, 50%)"

      iex> TinyColor.HSL.to_string(%TinyColor.HSL{hue: 128.0, saturation: 47.0, lightness: 50.0, alpha: 0.5})
      "hsla(128, 47%, 50%, 0.5)"

      iex> TinyColor.HSL.to_string(%TinyColor.HSL{hue: 128.0, saturation: 47.0, lightness: 50.0}, :hsla)
      "hsla(128, 47%, 50%, 1.0)"

      iex> TinyColor.HSL.to_string(%TinyColor.HSL{hue: 128.0, saturation: 47.0, lightness: 50.0, alpha: 0.5}, :hsla)
      "hsla(128, 47%, 50%, 0.5)"

  """
  def to_string(struct, type \\ nil)

  def to_string(%__MODULE__{hue: h, saturation: s, lightness: l, alpha: alpha}, :hsla) do
    "hsla(#{round(h)}, #{round(s)}%, #{round(l)}%, #{Float.round(alpha, 4)})"
  end

  def to_string(%__MODULE__{hue: h, saturation: s, lightness: l, alpha: 1.0}, _) do
    "hsl(#{round(h)}, #{round(s)}%, #{round(l)}%)"
  end

  def to_string(%__MODULE__{} = struct, _) do
    to_string(struct, :hsla)
  end

  def new(hue, saturation, lightness, alpha \\ 1.0) do
    %__MODULE__{
      hue: cast(hue, :hue),
      saturation: cast(saturation, :saturation),
      lightness: cast(lightness, :lightness),
      alpha: cast(alpha, :alpha)
    }
  end

  def percentages(%TinyColor.HSL{hue: h, saturation: s, lightness: l, alpha: a}) do
    {
      h / 360,
      s / 100,
      l / 100,
      a
    }
  end

  defimpl String.Chars do
    def to_string(struct) do
      TinyColor.HSL.to_string(struct)
    end
  end

  defimpl Jason.Encoder do
    def encode(value, opts) do
      Jason.Encode.string(TinyColor.HSL.to_string(value), opts)
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(value), do: to_string(value)
  end
end
