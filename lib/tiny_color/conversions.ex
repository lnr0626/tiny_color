defprotocol TinyColor.Conversions do
  @doc "converts a color into the sRGB color space"
  def to_rgb(color)
  @doc "converts a color into the HSL color space"
  def to_hsl(color)
  @doc "converts a color into the HSV color space"
  def to_hsv(color)
  @doc "converts a color into the OKLab color space"
  def to_oklab(color)
end

defimpl TinyColor.Conversions, for: Atom do
  def to_rgb(_), do: nil
  def to_hsl(_), do: nil
  def to_hsv(_), do: nil
  def to_oklab(_), do: nil
end
