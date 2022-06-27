defmodule FormMetal.MixProject do
  use Mix.Project

  def project do
    [
      app: :form_metal,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      dialyzer: dialyzer(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.8"},
      {:typed_struct, "~> 0.3.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      "code.check": ["format --check-formatted", "credo --strict", "dialyzer"]
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [],
      plt_add_deps: :app_tree,
      plt_file: {:no_warn, "priv/plts/form_metal.plt"}
    ]
  end
end
