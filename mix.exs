defmodule Presentir.Mixfile do
  use Mix.Project

  def project do
    [app: :presentir,
     version: "0.0.1",
     elixir: "~> 1.0.0-rc1",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger],
      mod: {PresentirApp, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:timex, "~> 0.12.4"},
      {:uuid, "~> 0.1.5"}
    ]
  end
end
