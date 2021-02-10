defimpl TinyColor.Conversions, for: TinyColor.OKLab do
  def to_oklab(color), do: color
  def to_hsv(color), do: color |> to_rgb() |> to_hsv()
  def to_hsl(color), do: color |> to_rgb() |> to_hsl()

  def to_rgb(%TinyColor.OKLab{l: l, a: a, b: b, alpha: alpha}) do
    l_ = l + 0.3963377774 * a + 0.2158037573 * b
    m_ = l - 0.1055613458 * a - 0.0638541728 * b
    s_ = l - 0.0894841775 * a - 1.2914855480 * b

    l_cubed = :math.pow(l_, 3)
    m_cubed = :math.pow(m_, 3)
    s_cubed = :math.pow(s_, 3)

    TinyColor.RGB.new(
      +4.0767245293 * l_cubed - 3.3072168827 * m_cubed + 0.2307590544 * s_cubed,
      -1.2681437731 * l_cubed + 2.6093323231 * m_cubed - 0.3411344290 * s_cubed,
      -0.0041119885 * l_cubed - 0.7034763098 * m_cubed + 1.7068625689 * s_cubed,
      alpha
    )
  end
end
