defmodule ExMsg91.MixProject do
  use Mix.Project

  @source_url "https://github.com/akki91/ex_msg91"

  def project do
    [
      app: :ex_msg91,
      version: "0.2.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/akki91/ex_msg91",
      package: package(),
      licenses: ["MIT"]
    ]
  end

  defp package do
    [
      description: description(),
      licenses: ["MIT"],
      links: %{
        "Github" => @source_url
      }
    ]
  end

  defp description() do
    "Elixir library for MSG91"
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
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end
end
