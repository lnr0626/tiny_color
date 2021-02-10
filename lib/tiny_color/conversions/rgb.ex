defimpl TinyColor.Conversions, for: TinyColor.RGB do
  def to_rgb(struct), do: struct

  def to_hsl(color) do
    {r, g, b, a} = TinyColor.RGB.percentages(color)

    max = Enum.max([r, g, b])
    min = Enum.min([r, g, b])

    l = (max + min) / 2

    if max == min do
      TinyColor.HSL.new(0, 0, {l, :percent}, a)
    else
      d = max - min

      s =
        if(l > 0.5) do
          d / (2 - max - min)
        else
          d / (max + min)
        end

      h =
        cond do
          max == r -> (g - b) / d + if g < b, do: 6, else: 0
          max == g -> (b - r) / d + 2
          max == b -> (r - g) / d + 4
          true -> 0
        end

      TinyColor.HSL.new({h / 6, :percent}, {s, :percent}, {l, :percent}, a)
    end
  end

  def to_hsv(color) do
    {r, g, b, a} = TinyColor.RGB.percentages(color)

    max = Enum.max([r, g, b])
    min = Enum.min([r, g, b])

    v = max
    d = max - min

    s =
      if max == 0 do
        0
      else
        d / max
      end

    if max == min do
      TinyColor.HSV.new(0, {s, :percent}, {v, :percent}, a)
    else
      h =
        cond do
          max == r ->
            (g - b) / d +
              if g < b do
                6
              else
                0
              end

          max == g ->
            (b - r) / d + 2

          max == b ->
            (r - g) / d + 4

          true ->
            0
        end

      TinyColor.HSV.new({h / 6, :percent}, {s, :percent}, {v, :percent}, a)
    end
  end

  def to_oklab(%TinyColor.RGB{red: red, blue: blue, green: green, alpha: alpha}) do
    l = 0.4121656120 * red + 0.5362752080 * green + 0.0514575653 * blue
    m = 0.2118591070 * red + 0.6807189584 * green + 0.1074065790 * blue
    s = 0.0883097947 * red + 0.2818474174 * green + 0.6302613616 * blue

    l_ = :math.pow(l, 1 / 3)
    m_ = :math.pow(m, 1 / 3)
    s_ = :math.pow(s, 1 / 3)

    TinyColor.OKLab.new(
      0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
      1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
      0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
      alpha
    )
  end
end
