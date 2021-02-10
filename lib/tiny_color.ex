defmodule TinyColor do
  @moduledoc """
  TinyColor is an elixir port of the javascript tinycolor2 library used to manipulate color values
  and convert them to different color spaces. Alpha is supported for all color spaces.

  Currently it supports RGB, HSV, HSL, and the OKLab color space. All supported color spaces can
  be used in any method; however, most operations are implemented by converting the provided color
  into a specific color space, and so there will be some additional accuracy loss.

  ## Parsing CSS colors
  `TinyColor.parser` defines a parser that will interpret CSS Level 3 compliant color codes into
  the appropriate TinyColor struct.

  ## Rendering colors in html and json
  TinyColor implements the protocol for Jason and Phoenix so that colors can be directly rendered in
  both HTML and json responses as css compatible color codes.
  """

  @white %TinyColor.RGB{red: 255, green: 255, blue: 255}
  @black %TinyColor.RGB{red: 0, green: 0, blue: 0}

  @typedoc """
    A representation of a color in hue, saturation, lightness and alpha.
  """
  @type hsl_color :: %TinyColor.HSL{
          hue: :float,
          saturation: :float,
          lightness: :float,
          alpha: :float
        }

  @typedoc """
    A representation of a color in hue, saturation, value and alpha.
  """
  @type hsv_color :: %TinyColor.HSV{
          hue: :float,
          saturation: :float,
          value: :float,
          alpha: :float
        }

  @typedoc """
    A representation of a color in red, green, blue and alpha.
  """
  @type rgb_color :: %TinyColor.RGB{
          red: :float,
          green: :float,
          blue: :float,
          alpha: :float
        }

  @typedoc """
    A representation of a color in the oklab color space with optional alpha
  """
  @type oklab_color :: %TinyColor.OKLab{
          l: :float,
          a: :float,
          b: :float,
          alpha: :float
        }

  @typedoc """
    A representation of a color in any supported system.
  """
  @type color :: hsl_color | hsv_color | rgb_color

  @doc ~S"""
  Parses the given values into an HSL struct

  ## Examples

      iex> TinyColor.hsl(128, 0.41, 0.13)
      %TinyColor.HSL{hue: 128.0, saturation: 41.0, lightness: 13.0, alpha: 1.0}

      iex> TinyColor.hsl(450, 0.41, 0.13)
      %TinyColor.HSL{alpha: 1.0, hue: 90.0, lightness: 13.0, saturation: 41.0}

      iex> TinyColor.hsl(128, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSL{hue: 128.0, saturation: 26.5, lightness: 54.0, alpha: 1.0}

      iex> TinyColor.hsl(450, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSL{alpha: 1.0, hue: 90.0, lightness: 54.0, saturation: 26.5}

      iex> TinyColor.hsl({0.54, :percent}, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSL{hue: 194.4, saturation: 26.5, lightness: 54.0, alpha: 1.0}

      iex> TinyColor.hsl({1.4, :percent}, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSL{alpha: 1.0, hue: 143.99999999999994, lightness: 54.0, saturation: 26.5}

      iex> TinyColor.hsl(128, 0.41, 0.13, 0.5)
      %TinyColor.HSL{hue: 128.0, saturation: 41.0, lightness: 13.0, alpha: 0.5}

      iex> TinyColor.hsl(450, 0.41, 0.13, 0.5)
      %TinyColor.HSL{alpha: 0.5, hue: 90.0, lightness: 13.0, saturation: 41.0}

      iex> TinyColor.hsl(128, {0.265, :percent}, {0.54, :percent}, 0.5)
      %TinyColor.HSL{hue: 128.0, saturation: 26.5, lightness: 54.0, alpha: 0.5}

      iex> TinyColor.hsl(450, {0.265, :percent}, {0.54, :percent}, 0.5)
      %TinyColor.HSL{alpha: 0.5, hue: 90.0, lightness: 54.0, saturation: 26.5}

      iex> TinyColor.hsl({0.54, :percent}, {0.265, :percent}, {0.54, :percent}, 0.5)
      %TinyColor.HSL{hue: 194.4, saturation: 26.5, lightness: 54.0, alpha: 0.5}

      iex> TinyColor.hsl({1.4, :percent}, {0.265, :percent}, {0.54, :percent}, 0.5)
      %TinyColor.HSL{alpha: 0.5, hue: 143.99999999999994, lightness: 54.0, saturation: 26.5}

  """
  def hsl(hue, saturation, lightness, alpha \\ 1.0) do
    TinyColor.HSL.new(hue, saturation, lightness, alpha)
  end

  @doc ~S"""
  Parses the given values into an HSL struct

  ## Examples

      iex> TinyColor.hsv(128, 0.41, 0.13)
      %TinyColor.HSV{hue: 128.0, saturation: 41.0, value: 13.0}

      iex> TinyColor.hsv(450, 0.41, 0.13)
      %TinyColor.HSV{hue: 90.0, saturation: 41.0, value: 13.0}

      iex> TinyColor.hsv(128, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSV{hue: 128.0, saturation: 26.5, value: 54.0}

      iex> TinyColor.hsv(450, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSV{hue: 90.0, saturation: 26.5, value: 54.0}

      iex> TinyColor.hsv({0.54, :percent}, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSV{hue: 194.4, saturation: 26.5, value: 54.0}

      iex> TinyColor.hsv({1.4, :percent}, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSV{hue: 143.99999999999994, saturation: 26.5, value: 54.0}

      iex> TinyColor.hsv(128, 0.41, 0.13)
      %TinyColor.HSV{hue: 128.0, saturation: 41.0, value: 13.0, alpha: 1.0}

      iex> TinyColor.hsv(450, 0.41, 0.13)
      %TinyColor.HSV{alpha: 1.0, hue: 90.0, saturation: 41.0, value: 13.0}

      iex> TinyColor.hsv(128, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSV{hue: 128.0, saturation: 26.5, value: 54.0, alpha: 1.0}

      iex> TinyColor.hsv(450, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSV{alpha: 1.0, hue: 90.0, saturation: 26.5, value: 54.0}

      iex> TinyColor.hsv({0.54, :percent}, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSV{hue: 194.4, saturation: 26.5, value: 54.0, alpha: 1.0}

      iex> TinyColor.hsv({1.4, :percent}, {0.265, :percent}, {0.54, :percent})
      %TinyColor.HSV{alpha: 1.0, hue: 143.99999999999994, saturation: 26.5, value: 54.0}

      iex> TinyColor.hsv(128, 0.41, 0.13, 0.5)
      %TinyColor.HSV{hue: 128.0, saturation: 41.0, value: 13.0, alpha: 0.5}

      iex> TinyColor.hsv(450, 0.41, 0.13, 0.5)
      %TinyColor.HSV{alpha: 0.5, hue: 90.0, saturation: 41.0, value: 13.0}

      iex> TinyColor.hsv(128, {0.265, :percent}, {0.54, :percent}, 0.5)
      %TinyColor.HSV{hue: 128.0, saturation: 26.5, value: 54.0, alpha: 0.5}

      iex> TinyColor.hsv(450, {0.265, :percent}, {0.54, :percent}, 0.5)
      %TinyColor.HSV{alpha: 0.5, hue: 90.0, saturation: 26.5, value: 54.0}

      iex> TinyColor.hsv({0.54, :percent}, {0.265, :percent}, {0.54, :percent}, 0.5)
      %TinyColor.HSV{hue: 194.4, saturation: 26.5, value: 54.0, alpha: 0.5}

      iex> TinyColor.hsv({1.4, :percent}, {0.265, :percent}, {0.54, :percent}, 0.5)
      %TinyColor.HSV{alpha: 0.5, hue: 143.99999999999994, saturation: 26.5, value: 54.0}

  """
  def hsv(hue, saturation, value, alpha \\ 1.0) do
    TinyColor.HSV.new(hue, saturation, value, alpha)
  end

  @doc ~S"""
  Parses the given values into an RGB struct

  ## Examples

      iex> TinyColor.rgb(128, 129, 130)
      %TinyColor.RGB{red: 128.0, green: 129.0, blue: 130.0, alpha: 1.0}

      iex> TinyColor.rgb(333, 129, 130)
      %TinyColor.RGB{alpha: 1.0, blue: 130.0, green: 129.0, red: 255.0}

      iex> TinyColor.rgb(128, 129, 130, 0.5)
      %TinyColor.RGB{red: 128.0, green: 129.0, blue: 130.0, alpha: 0.5}

      iex> TinyColor.rgb(128, 129, 130, -0.5)
      %TinyColor.RGB{alpha: 0.0, blue: 130.0, green: 129.0, red: 128.0}

      iex> TinyColor.rgb({0.125, :percent}, {0.265, :percent}, {0.525, :percent})
      %TinyColor.RGB{red: 31.875, green: 67.575, blue: 133.875, alpha: 1.0}

      iex> TinyColor.rgb({1.4, :percent}, {0.265, :percent}, {0.54, :percent})
      %TinyColor.RGB{alpha: 1.0, blue: 137.70000000000002, green: 67.575, red: 255.0}

      iex> TinyColor.rgb({0.125, :percent}, {0.265, :percent}, {0.525, :percent}, 0.5)
      %TinyColor.RGB{red: 31.875, green: 67.575, blue: 133.875, alpha: 0.5}

      iex> TinyColor.rgb({0.54, :percent}, {0.265, :percent}, {0.54, :percent}, -0.5)
      %TinyColor.RGB{alpha: 0.0, blue: 137.70000000000002, green: 67.575, red: 137.70000000000002}

  """
  def rgb(red, green, blue, alpha \\ 1.0) do
    TinyColor.RGB.new(red, green, blue, alpha)
  end

  def oklab(l, a, b, alpha \\ 1.0) do
    TinyColor.OKLab.new(l, a, b, alpha)
  end

  def light?(color) do
    not dark?(color)
  end

  def dark?(color) do
    brightness(color) < 128
  end

  def brightness(color) do
    %{red: r, blue: b, green: g} = TinyColor.Conversions.to_rgb(color)

    (r * 299 + g * 587 + b * 114) / 1000
  end

  @spec luminance(color()) :: float
  def luminance(color) do
    {rs_rgb, gs_rgb, bs_rgb, _} =
      color
      |> TinyColor.Conversions.to_rgb()
      |> TinyColor.RGB.percentages()

    r =
      if rs_rgb <= 0.03928 do
        rs_rgb / 12.92
      else
        :math.pow((rs_rgb + 0.055) / 1.055, 2.4)
      end

    g =
      if gs_rgb <= 0.03928 do
        gs_rgb / 12.92
      else
        :math.pow((gs_rgb + 0.055) / 1.055, 2.4)
      end

    b =
      if bs_rgb <= 0.03928 do
        bs_rgb / 12.92
      else
        :math.pow((bs_rgb + 0.055) / 1.055, 2.4)
      end

    0.2126 * r + 0.7152 * g + 0.0722 * b
  end

  def lighten(color, amount \\ 10) do
    color = TinyColor.Conversions.to_hsl(color)

    TinyColor.hsl(color.hue, color.lightness + amount, color.saturation, color.alpha)
  end

  def brighten(color, amount \\ 10) do
    %{red: r, green: g, blue: b, alpha: a} = TinyColor.Conversions.to_rgb(color)

    TinyColor.rgb(
      r - round(255 * -(amount / 100)),
      g - round(255 * -(amount / 100)),
      b - round(255 * -(amount / 100)),
      a
    )
  end

  def darken(color, amount \\ 10) do
    color = TinyColor.Conversions.to_hsl(color)

    TinyColor.hsl(color.hue, color.lightness - amount, color.saturation, color.alpha)
  end

  def tint(color, amount \\ 10) do
    mix(color, TinyColor.Named.get("white"), amount)
  end

  def shade(color, amount \\ 10) do
    mix(color, TinyColor.Named.get("black"), amount)
  end

  def desaturate(color, amount \\ 10) do
    color = TinyColor.Conversions.to_hsl(color)

    TinyColor.hsl(color.hue, color.lightness, color.saturation - amount, color.alpha)
  end

  def saturate(color, amount \\ 10) do
    color = TinyColor.Conversions.to_hsl(color)

    TinyColor.hsl(color.hue, color.lightness, color.saturation + amount, color.alpha)
  end

  def grayscale(color), do: desaturate(color, 100)

  def spin(color, amount) do
    color = TinyColor.Conversions.to_hsl(color)

    TinyColor.hsl(color.hue + amount, color.lightness, color.saturation, color.alpha)
  end

  def mix(self, color, amount \\ 50) do
    %{red: r1, green: g1, blue: b1, alpha: a1} = TinyColor.Conversions.to_rgb(self)
    %{red: r2, green: g2, blue: b2, alpha: a2} = TinyColor.Conversions.to_rgb(color)

    percentage = amount / 100

    TinyColor.rgb(
      (r2 - r1) * percentage + r1,
      (g2 - g1) * percentage + g1,
      (b2 - b1) * percentage + b1,
      (a2 - a1) * percentage + a1
    )
  end

  @spec contrast(color(), color()) :: float()
  def contrast(color1, color2) do
    c1_luminance = luminance(color1)
    c2_luminance = luminance(color2)

    (max(c1_luminance, c2_luminance) + 0.05) / (min(c1_luminance, c2_luminance) + 0.05)
  end

  @type font_size_option :: {:size, :small | :large}
  @type contrast_level_option :: {:level, :AA | :AAA}

  @spec readable?(color(), color(), [font_size_option() | contrast_level_option()]) ::
          boolean()
  def readable?(color1, color2, opts \\ []) do
    level = Keyword.get(opts, :level, :AA)
    size = Keyword.get(opts, :size, :small)

    case {level, size, contrast(color1, color2)} do
      {:AAA, :small, level} -> level >= 7
      {:AAA, :large, level} -> level >= 4.5
      {:AA, :small, level} -> level >= 4.5
      {:AA, :large, level} -> level >= 3
      _ -> false
    end
  end

  @spec most_readable(
          color(),
          list(color()),
          [{atom, [any]}]
        ) :: color()
  def most_readable(base, choices, opts \\ []) do
    best_choice = Enum.max_by(choices, fn choice -> contrast(base, choice) end)

    include_fallbacks = Keyword.get(opts, :include_fallback_colors, false)

    if readable?(base, best_choice, opts) or not include_fallbacks do
      best_choice
    else
      most_readable(base, [@white, @black])
    end
  end

  @doc """
  Checks for equality of two colors.

  """
  @spec equal?(any, any) :: boolean
  def equal?(nil, nil), do: true
  def equal?(nil, _), do: false
  def equal?(_, nil), do: false

  def equal?(%TinyColor.RGB{} = a, %TinyColor.RGB{} = b), do: a == b
  def equal?(%TinyColor.HSL{} = a, %TinyColor.HSL{} = b), do: a == b
  def equal?(%TinyColor.HSV{} = a, %TinyColor.HSV{} = b), do: a == b

  def equal?(color1, color2) do
    a = color1 |> TinyColor.Conversions.to_rgb() |> to_string()
    b = color2 |> TinyColor.Conversions.to_rgb() |> to_string()
    a == b
  end
end
