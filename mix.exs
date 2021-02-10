defmodule TinyColor.MixProject do
  use Mix.Project

  def project do
    [
      app: :tiny_color,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/lnr0626/tiny_color"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:phoenix_html, "~> 2.13"},
      {:nimble_parsec, "~> 1.1.0"}
    ]
  end
end