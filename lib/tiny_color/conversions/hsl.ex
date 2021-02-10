defimpl TinyColor.Conversions, for: TinyColor.HSL do
  def to_hsl(struct), do: struct

  def to_rgb(color) do
    {h, s, l, a} = TinyColor.HSL.percentages(color)

    if(s == 0) do
      TinyColor.RGB.new({l, :percent}, {l, :percent}, {l, :percent}, a)
    else
      q =
        if l < 0.5 do
          l * (1 + s)
        else
          l + s - l * s
        end

      p = 2 * l - q

      r = hue_to_rgb(p, q, h + 1 / 3)
      g = hue_to_rgb(p, q, h)
      b = hue_to_rgb(p, q, h - 1 / 3)

      TinyColor.RGB.new({r, :percent}, {g, :percent}, {b, :percent}, a)
    end
  end

  def to_hsv(%TinyColor.HSL{hue: h, saturation: s, lightness: l, alpha: a}) do
    s = s / 100
    l = l / 100

    v = l + s * min(l, 1 - l)

    s_v =
      if v == 0 do
        0
      else
        2 * (1 - l / v)
      end

    TinyColor.HSV.new(h, {s_v, :percent}, {v, :percent}, a)
  end

  def to_oklab(color), do: color |> to_rgb() |> to_oklab()

  def hue_to_rgb(p, q, t) do
    cond do
      t < 0 -> hue_to_rgb(p, q, t + 1)
      t > 1 -> hue_to_rgb(p, q, t - 1)
      t < 1 / 6 -> p + (q - p) * (6 * t)
      t < 1 / 2 -> q
      t < 2 / 3 -> p + (q - p) * (2 / 3 - t) * 6
      true -> p
    end
  end
end
