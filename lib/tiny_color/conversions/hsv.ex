defimpl TinyColor.Conversions, for: TinyColor.HSV do
  def to_hsv(struct), do: struct

  def to_rgb(color) do
    {h, s, v, a} = TinyColor.HSV.percentages(color)

    h = h * 6

    i = Kernel.trunc(h)
    f = h - i
    p = v * (1 - s)
    q = v * (1 - f * s)
    t = v * (1 - (1 - f) * s)
    mod = rem(i, 6)

    r = Enum.at([v, q, p, p, t, v], mod)
    g = Enum.at([t, v, v, q, p, p], mod)
    b = Enum.at([p, p, t, v, v, q], mod)

    TinyColor.RGB.new({r, :percent}, {g, :percent}, {b, :percent}, a)
  end

  def to_hsl(%TinyColor.HSV{hue: h, saturation: s, value: v, alpha: a}) do
    s = s / 100
    v = v / 100

    l = v * (1 - s / 2)

    s_l =
      if l == 0 or l == 1 do
        0
      else
        (v - l) / min(l, 1 - l)
      end

    TinyColor.HSL.new(h, {s_l, :percent}, {l, :percent}, a)
  end

  def to_oklab(color), do: color |> to_rgb() |> to_oklab()
end
