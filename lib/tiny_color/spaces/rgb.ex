defmodule TinyColor.RGB do
  @moduledoc """
  Represents a color in the for of red, green, blue, and optional alpha
  """
  import TinyColor.Normalize

  defstruct red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0

  @doc ~S"""
  Returns a string representation of this color. hex is only supported if alpha == 1.0

  ## Examples

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0, alpha: 1.0})
      "#8081BE"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0})
      "#8081BE"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0, alpha: 0.5})
      "rgba(128, 129, 190, 0.5)"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0}, :hex)
      "#8081BE"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0, alpha: 1.0}, :hex)
      "#8081BE"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0, alpha: 0.5}, :hex)
      "#8081BE80"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0}, :rgb)
      "rgb(128, 129, 190)"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0, alpha: 1.0}, :rgb)
      "rgb(128, 129, 190)"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0}, :rgba)
      "rgba(128, 129, 190, 1.0)"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0, alpha: 1.0}, :rgba)
      "rgba(128, 129, 190, 1.0)"

      iex> TinyColor.RGB.to_string(%TinyColor.RGB{red: 128.0, green: 129.0, blue: 190.0, alpha: 0.5}, :rgba)
      "rgba(128, 129, 190, 0.5)"

  """
  def to_string(struct, type \\ nil)

  def to_string(%__MODULE__{} = struct, nil) do
    type =
      case struct.alpha do
        1.0 -> :hex
        _ -> :rgba
      end

    to_string(struct, type)
  end

  def to_string(%__MODULE__{red: r, green: g, blue: b, alpha: alpha}, :rgba) do
    "rgba(#{round(r)}, #{round(g)}, #{round(b)}, #{Float.round(alpha, 4)})"
  end

  def to_string(%__MODULE__{red: r, green: g, blue: b, alpha: 1.0}, :rgb) do
    "rgb(#{round(r)}, #{round(g)}, #{round(b)})"
  end

  def to_string(%__MODULE__{red: r, green: g, blue: b, alpha: 1.0}, _) do
    "#" <> to_hex(r) <> to_hex(g) <> to_hex(b)
  end

  def to_string(%__MODULE__{red: r, green: g, blue: b, alpha: alpha}, :hex) do
    "#" <> to_hex(r) <> to_hex(g) <> to_hex(b) <> to_hex(alpha * 255)
  end

  defp to_hex(value) when is_float(value), do: to_hex(round(value))
  defp to_hex(value) when value < 16 and value >= 0, do: "0" <> Integer.to_string(value, 16)
  defp to_hex(value) when is_integer(value), do: Integer.to_string(value, 16)

  def new(red, green, blue, alpha \\ 1.0) do
    %__MODULE__{
      red: cast(red, :red),
      green: cast(green, :green),
      blue: cast(blue, :blue),
      alpha: cast(alpha, :alpha)
    }
  end

  def percentages(%TinyColor.RGB{red: r, green: g, blue: b, alpha: a}) do
    {
      r / 255,
      g / 255,
      b / 255,
      a
    }
  end

  defimpl String.Chars do
    def to_string(struct) do
      TinyColor.RGB.to_string(struct)
    end
  end

  defimpl Jason.Encoder do
    def encode(value, opts) do
      Jason.Encode.string(TinyColor.RGB.to_string(value), opts)
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(value), do: to_string(value)
  end
end
