defmodule TinyColor.Parser do
  @moduledoc """
  Provides a parser for css 3 color strings
  """
  import NimbleParsec

  sign = choice([string("+"), string("-")]) |> label("number sign")

  css_integer =
    optional(sign)
    |> utf8_string([?0..?9], min: 1)
    |> reduce({Enum, :join, [""]})
    |> map({String, :to_integer, []})
    |> optional(string("%") |> replace(:percent))
    |> label("css_integer")

  css_number =
    optional(sign)
    |> utf8_string([?0..?9], min: 0)
    |> string(".")
    |> utf8_string([?0..?9], min: 1)
    |> reduce({Enum, :join, [""]})
    |> map({String, :to_float, []})
    |> optional(string("%") |> replace(:percent))
    |> label("css_number")

  css_unit =
    wrap(choice([css_number, css_integer]))
    |> map(:parse_css_unit)

  whitespace =
    choice([string(" "), string("\n"), string("\t"), string("\r"), string("\f"), string("\v")])
    |> label("whitespace")

  permissive_match3 =
    ignore(
      choice([string("("), whitespace])
      |> repeat(whitespace)
    )
    |> concat(css_unit)
    |> ignore(choice([string(","), whitespace]) |> repeat(whitespace))
    |> concat(css_unit)
    |> ignore(choice([string(","), whitespace]) |> repeat(whitespace))
    |> concat(css_unit)
    |> ignore(repeat(whitespace) |> optional(string(")")))
    |> label("3 units with optional parenthesis")

  permissive_match4 =
    ignore(
      choice([string("("), whitespace])
      |> repeat(whitespace)
    )
    |> concat(css_unit)
    |> ignore(choice([string(","), whitespace]) |> repeat(whitespace))
    |> concat(css_unit)
    |> ignore(choice([string(","), whitespace]) |> repeat(whitespace))
    |> concat(css_unit)
    |> ignore(choice([string(","), whitespace]) |> repeat(whitespace))
    |> concat(css_unit)
    |> ignore(repeat(whitespace) |> optional(string(")")))
    |> label("4 units with optional parenthesis")

  octal =
    utf8_string(empty(), [?0..?9, ?a..?f, ?A..?F], 1)
    |> map(:octal_to_hex)
    |> map({String, :to_integer, [16]})
    |> label("single digit hex number")

  hex =
    utf8_string(empty(), [?0..?9, ?a..?f, ?A..?F], 2)
    |> map({String, :to_integer, [16]})
    |> label("double digit hex number")

  hex3 =
    ignore(optional(string("#"))) |> replace(:rgb) |> wrap(duplicate(octal, 3)) |> label("#?FFF")

  hex4 =
    ignore(optional(string("#")))
    |> replace(:rgb)
    |> wrap(duplicate(octal, 3) |> concat(map(octal, :normalize_alpha)))
    |> label("#?FFFF")

  hex6 =
    ignore(optional(string("#"))) |> replace(:rgb) |> wrap(duplicate(hex, 3)) |> label("#?FFFFFF")

  hex8 =
    ignore(optional(string("#")))
    |> replace(:rgb)
    |> wrap(duplicate(hex, 3) |> concat(map(hex, :normalize_alpha)))
    |> label("#?FFFFFFFF")

  rgba = string("rgba") |> replace(:rgb) |> wrap(permissive_match4) |> label("rgba(r, b, g, a)")

  rgb = string("rgb") |> replace(:rgb) |> wrap(permissive_match3) |> label("rgb(r, b, g)")

  hsla = string("hsla") |> replace(:hsl) |> wrap(permissive_match4) |> label("hsla(h, s, l, a)")

  hsl = string("hsl") |> replace(:hsl) |> wrap(permissive_match3) |> label("hsl(h, s, l)")

  hsva = string("hsva") |> replace(:hsv) |> wrap(permissive_match4) |> label("hsva(h, s, v, a)")

  hsv = string("hsv") |> replace(:hsv) |> wrap(permissive_match3) |> label("hsv(h, s, v)")

  oklab = string("oklab") |> replace(:oklab) |> wrap(permissive_match3) |> label("oklab(h, s, v)")

  oklaba =
    string("oklaba") |> replace(:oklab) |> wrap(permissive_match4) |> label("oklaba(h, s, v, a)")

  css_color =
    choice([
      rgba,
      rgb,
      hsla,
      hsl,
      hsva,
      hsv,
      oklaba,
      oklab,
      hex8,
      hex6,
      hex4,
      hex3
    ])
    |> ignore(repeat(whitespace))
    |> eos()

  defparsec(:css_unit, css_unit, inline: true)
  defparsec(:css_color, css_color, inline: true)

  defp parse_css_unit([value]), do: value
  defp parse_css_unit([value, :percent]), do: {value / 100, :percent}

  defp octal_to_hex(octal) do
    octal <> octal
  end

  defp normalize_alpha(value), do: value / 255

  @doc ~S"""
  Parses a CSS Level 3 compliant color code into a TinyColor struct

  ## Examples

      iex> TinyColor.Parser.parse("#08f")
      {:ok, %TinyColor.RGB{red: 0.0, green: 136.0, blue: 255.0}}

      iex> TinyColor.Parser.parse("#08ff")
      {:ok, %TinyColor.RGB{red: 0.0, green: 136.0, blue: 255.0, alpha: 1.0}}

      iex> TinyColor.Parser.parse("rgb(0, 128, 255)")
      {:ok, %TinyColor.RGB{red: 0.0, green: 128.0, blue: 255.0}}

      iex> TinyColor.Parser.parse("rgb 0% 50% 100%")
      {:ok, %TinyColor.RGB{red: 0.0, green: 127.5, blue: 255.0}}

      iex> TinyColor.Parser.parse("rgba(0, 128, 255, 0.5)")
      {:ok, %TinyColor.RGB{red: 0.0, green: 128.0, blue: 255.0, alpha: 0.5}}

      iex> TinyColor.Parser.parse("rgba 0% 50% 100% 50%")
      {:ok, %TinyColor.RGB{red: 0.0, green: 127.5, blue: 255.0, alpha: 0.5}}

      iex> TinyColor.Parser.parse("rgba(0, 128, 255, 1.0)")
      {:ok, %TinyColor.RGB{red: 0.0, green: 128.0, blue: 255.0, alpha: 1.0}}

  """
  def parse(color) do
    case TinyColor.Named.get(color) do
      nil ->
        with {:ok, [fun, args], "", _, _, _} <-
               css_color(color) do
          {:ok, apply(TinyColor, fun, args)}
        end

      color ->
        {:ok, color}
    end
  end

  def parse!(color) do
    {:ok, color} = parse(color)

    color
  end
end
