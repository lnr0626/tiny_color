defmodule TinyColor.ConversionsTest do
  use ExUnit.Case, async: true

  for %{hex: hex, hex8: hex8, rgb: rgb, hsv: hsv, hsl: hsl} <- [
        %{
          hex: "#FFFFFF",
          hex8: "#FFFFFFFF",
          rgb: "rgb(100.0%, 100.0%, 100.0%)",
          hsv: "hsv(0, 0.000, 1.000)",
          hsl: "hsl(0, 0.000, 1.000)"
        },
        %{
          hex: "#808080",
          hex8: "#808080FF",
          rgb: "rgb(050.0%, 050.0%, 050.0%)",
          hsv: "hsv(0, 0.000, 0.500)",
          hsl: "hsl(0, 0.000, 0.500)"
        },
        %{
          hex: "#000000",
          hex8: "#000000FF",
          rgb: "rgb(000.0%, 000.0%, 000.0%)",
          hsv: "hsv(0, 0.000, 0.000)",
          hsl: "hsl(0, 0.000, 0.000)"
        },
        %{
          hex: "#FF0000",
          hex8: "#FF0000FF",
          rgb: "rgb(100.0%, 000.0%, 000.0%)",
          hsv: "hsv(0.0, 1.000, 1.000)",
          hsl: "hsl(0.0, 1.000, 0.500)"
        },
        %{
          hex: "#BFBF00",
          hex8: "#BFBF00FF",
          rgb: "rgb(075.0%, 075.0%, 000.0%)",
          hsv: "hsv(60.0, 1.000, 0.750)",
          hsl: "hsl(60.0, 1.000, 0.375)"
        },
        %{
          hex: "#008000",
          hex8: "#008000FF",
          rgb: "rgb(000.0%, 050.0%, 000.0%)",
          hsv: "hsv(120.0, 1.000, 0.500)",
          hsl: "hsl(120.0, 1.000, 0.250)"
        },
        %{
          hex: "#80FFFF",
          hex8: "#80FFFFFF",
          rgb: "rgb(050.0%, 100.0%, 100.0%)",
          hsv: "hsv(180.0, 0.500, 1.000)",
          hsl: "hsl(180.0, 1.000, 0.750)"
        },
        %{
          hex: "#8080FF",
          hex8: "#8080FFFF",
          rgb: "rgb(050.0%, 050.0%, 100.0%)",
          hsv: "hsv(240.0, 0.500, 1.000)",
          hsl: "hsl(240.0, 1.000, 0.750)"
        },
        %{
          hex: "#BF40BF",
          hex8: "#BF40BFFF",
          rgb: "rgb(075.0%, 025.0%, 075.0%)",
          hsv: "hsv(300.0, 0.667, 0.750)",
          hsl: "hsl(300.0, 0.500, 0.500)"
        },
        %{
          hex: "#A0A424",
          hex8: "#A0A424FF",
          rgb: "rgb(062.8%, 064.3%, 014.2%)",
          hsv: "hsv(61.8, 0.779, 0.643)",
          hsl: "hsl(61.8, 0.638, 0.393)"
        },
        %{
          hex: "#1EAC41",
          hex8: "#1EAC41FF",
          rgb: "rgb(011.6%, 067.5%, 025.5%)",
          hsv: "hsv(134.9, 0.828, 0.675)",
          hsl: "hsl(134.9, 0.707, 0.396)"
        },
        %{
          hex: "#B430E5",
          hex8: "#B430E5FF",
          rgb: "rgb(070.4%, 018.7%, 089.7%)",
          hsv: "hsv(283.7, 0.792, 0.897)",
          hsl: "hsl(283.7, 0.775, 0.542)"
        },
        %{
          hex: "#FEF888",
          hex8: "#FEF888FF",
          rgb: "rgb(099.8%, 097.4%, 053.2%)",
          hsv: "hsv(56.9, 0.467, 0.998)",
          hsl: "hsl(56.9, 0.991, 0.765)"
        },
        %{
          hex: "#19CB97",
          hex8: "#19CB97FF",
          rgb: "rgb(009.9%, 079.5%, 059.1%)",
          hsv: "hsv(162.4, 0.875, 0.795)",
          hsl: "hsl(162.4, 0.779, 0.447)"
        },
        %{
          hex: "#362698",
          hex8: "#362698FF",
          rgb: "rgb(021.1%, 014.9%, 059.7%)",
          hsv: "hsv(248.3, 0.750, 0.597)",
          hsl: "hsl(248.3, 0.601, 0.373)"
        },
        %{
          hex: "#7E7EB8",
          hex8: "#7E7EB8FF",
          rgb: "rgb(049.5%, 049.3%, 072.1%)",
          hsv: "hsv(240.5, 0.316, 0.721)",
          hsl: "hsl(240.5, 0.290, 0.607)"
        }
      ] do
    test "#{hex} should be equivalent colors as rgb strings" do
      assert as_rgb_str(unquote(rgb)) == as_rgb_str(unquote(hex))
      assert as_rgb_str(unquote(rgb)) == as_rgb_str(unquote(hex8))
      assert as_rgb_str(unquote(rgb)) == as_rgb_str(unquote(hsl))
      assert as_rgb_str(unquote(rgb)) == as_rgb_str(unquote(hsv))
      assert as_rgb_str(unquote(rgb)) == as_rgb_str(unquote(rgb))
      assert as_rgb_str(unquote(hex)) == as_rgb_str(unquote(hex))
      assert as_rgb_str(unquote(hex)) == as_rgb_str(unquote(hex8))
      assert as_rgb_str(unquote(hex)) == as_rgb_str(unquote(hsl))
      assert as_rgb_str(unquote(hex)) == as_rgb_str(unquote(hsv))
    end

    test "#{hex} hsl -> rgb conversion" do
      expected = parsed(unquote(rgb))
      actual = parsed(unquote(hsl)) |> TinyColor.Conversions.to_rgb()

      assert_in_delta(expected.red, actual.red, 2)
      assert_in_delta(expected.green, actual.green, 2)
      assert_in_delta(expected.blue, actual.blue, 2)
      assert expected.alpha == actual.alpha
    end

    test "#{hex} hsl -> hsv conversion" do
      expected = parsed(unquote(hsv))
      actual = parsed(unquote(hsl)) |> TinyColor.Conversions.to_hsv()

      assert_in_delta(expected.hue, actual.hue, 1)
      assert_in_delta(expected.saturation, actual.saturation, 1)
      assert_in_delta(expected.value, actual.value, 1)
      assert expected.alpha == actual.alpha
    end

    test "#{hex} hsl -> hsl conversion" do
      expected = parsed(unquote(hsl))
      actual = parsed(unquote(hsl)) |> TinyColor.Conversions.to_hsl()

      assert expected == actual
    end

    test "#{hex} hsv -> rgb conversion" do
      expected = parsed(unquote(rgb))
      actual = parsed(unquote(hsv)) |> TinyColor.Conversions.to_rgb()

      assert_in_delta(expected.red, actual.red, 2)
      assert_in_delta(expected.green, actual.green, 2)
      assert_in_delta(expected.blue, actual.blue, 2)
      assert expected.alpha == actual.alpha
    end

    test "#{hex} hsv -> hsv conversion" do
      expected = parsed(unquote(hsv))
      actual = parsed(unquote(hsv)) |> TinyColor.Conversions.to_hsv()

      assert expected == actual
    end

    test "#{hex} hsv -> hsl conversion" do
      expected = parsed(unquote(hsl))
      actual = parsed(unquote(hsv)) |> TinyColor.Conversions.to_hsl()

      assert_in_delta(expected.hue, actual.hue, 1)
      assert_in_delta(expected.saturation, actual.saturation, 1)
      assert_in_delta(expected.lightness, actual.lightness, 1)
      assert expected.alpha == actual.alpha
    end

    test "#{hex} rgb -> rgb conversion" do
      expected = parsed(unquote(rgb))
      actual = parsed(unquote(rgb)) |> TinyColor.Conversions.to_rgb()

      assert expected == actual
    end

    test "#{hex} rgb -> hsv conversion" do
      expected = parsed(unquote(hsv))
      actual = parsed(unquote(rgb)) |> TinyColor.Conversions.to_hsv()

      assert_in_delta(expected.hue, actual.hue, 1)
      assert_in_delta(expected.saturation, actual.saturation, 1)
      assert_in_delta(expected.value, actual.value, 1)
      assert expected.alpha == actual.alpha
    end

    test "#{hex} rgb -> hsl conversion" do
      expected = parsed(unquote(hsl))
      actual = parsed(unquote(rgb)) |> TinyColor.Conversions.to_hsl()

      assert_in_delta(expected.hue, actual.hue, 1)
      assert_in_delta(expected.saturation, actual.saturation, 1)
      assert_in_delta(expected.lightness, actual.lightness, 1)
      assert expected.alpha == actual.alpha
    end

    test "#{rgb} round trips through oklab" do
      rgb = parsed(unquote(rgb))

      actual = rgb |> TinyColor.Conversions.to_oklab() |> TinyColor.Conversions.to_rgb()

      assert_in_delta(rgb.red, actual.red, 1)
      assert_in_delta(rgb.green, actual.green, 1)
      assert_in_delta(rgb.blue, actual.blue, 1)
      assert rgb.alpha == actual.alpha
    end
  end

  defp parsed(color), do: TinyColor.Parser.parse!(color)

  defp as_rgb(color) do
    color
    |> parsed()
    |> TinyColor.Conversions.to_rgb()
  end

  defp as_rgb_str(color) do
    color
    |> as_rgb()
    |> TinyColor.RGB.to_string(:rgba)
  end
end
