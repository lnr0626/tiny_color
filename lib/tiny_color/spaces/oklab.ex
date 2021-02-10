defmodule TinyColor.OKLab do
  @moduledoc """
  Represents a color in the for of red, green, blue, and optional alpha
  """
  defstruct l: 0.0, a: 0.0, b: 0.0, alpha: 1.0

  import TinyColor.Normalize

  @doc ~S"""
  Returns a string representation of this color.

  ## Examples

      iex> TinyColor.OKLab.to_string(%TinyColor.OKLab{l: 128.0, a: 47.0, b: 50.0})
      "oklab(128, 47, 50)"

      iex> TinyColor.OKLab.to_string(%TinyColor.OKLab{l: 128.0, a: 47.0, b: 50.0, alpha: 0.5})
      "oklab(128, 47, 50, 0.5)"

      iex> TinyColor.OKLab.to_string(%TinyColor.OKLab{l: 128.0, a: 47.0, b: 50.0}, :laba)
      "oklab(128, 47, 50, 1.0)"

      iex> TinyColor.OKLab.to_string(%TinyColor.OKLab{l: 128.0, a: 47.0, b: 50.0, alpha: 0.5}, :laba)
      "oklab(128, 47, 50, 0.5)"

  """
  def to_string(struct, type \\ nil)

  def to_string(%__MODULE__{l: l, a: a, b: b, alpha: alpha}, :laba) do
    "oklaba(#{Float.round(l, 4)}, #{Float.round(a, 4)}, #{Float.round(b, 4)}, #{
      Float.round(alpha, 4)
    })"
  end

  def to_string(%__MODULE__{l: l, a: a, b: b, alpha: 1.0}, _) do
    "oklab(#{Float.round(l, 4)}, #{Float.round(a, 4)}, #{Float.round(b, 4)})"
  end

  def to_string(%__MODULE__{} = struct, _) do
    to_string(struct, :laba)
  end

  def new(l, a, b, alpha \\ 1.0) do
    %__MODULE__{
      l: l,
      a: a,
      b: b,
      alpha: cast(alpha, :alpha)
    }
  end

  defimpl String.Chars do
    def to_string(struct) do
      TinyColor.OKLab.to_string(struct)
    end
  end

  defimpl Jason.Encoder do
    def encode(color, opts) do
      color |> TinyColor.Conversions.to_rgb() |> Jason.Encode.string(opts)
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(color), do: color |> TinyColor.Conversions.to_rgb() |> to_string()
  end
end
