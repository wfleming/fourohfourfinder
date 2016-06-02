defmodule FourOhFourFinderApp.Mixfile do
  use Mix.Project

  def project do
    [app: :four_oh_four_finder,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {FourOhFourFinderApp, []},
     applications: [
       :phoenix, :phoenix_html, :cowboy, :logger, :gettext, :httpoison, :raygun,
       :tzdata, :new_relixir, :ex_rated
     ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:cowboy, "~> 1.0"},
     {:ex_rated, "~> 1.2"},
     {:floki, "~> 0.8.1"},
     {:gettext, "~> 0.9"},
     {:httpoison, "~> 0.8.0"},
     {:new_relixir, "~> 0.1.0"},
     {:phoenix_html, "~> 2.4"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:phoenix, "~> 1.1.4"},
     {:raygun, "~> 0.3.0"}]
  end
end
