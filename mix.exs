defmodule ExquisitleUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "test.watch": :test
      ]
    ]
  end

  defp deps do
    [
      # Code coverage and test helpers
      {:excoveralls, "~> 0.10", only: :test},
      # Static code analysis and linter
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  def aliases do
    [
      quality: [
        "format",
        "credo --strict",
        "dialyzer",
        "test.watch"
      ],
      "assets.deploy": ["esbuild default --minify", "phx.digest"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run apps/dictionary/priv/repo/seeds.exs"]
    ]
  end
end
