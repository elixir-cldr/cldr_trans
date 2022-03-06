defmodule Cldr.Trans.Mixfile do
  use Mix.Project

  @version "1.0.0-rc.0"

  def project do
    [
      app: :ex_cldr_trans,
      version: @version,
      elixir: "~> 1.10",
      description: "CLDR-based embedded translations for Elixir schemas",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      app_list: app_list(Mix.env()),
      package: package(),
      deps: deps(),

      # Docs
      name: "Cldr Trans",
      source_url: "https://github.com/elixir-cldr/cldr_trans",
      homepage_url: "https://hex.pm/packages/ex_cldr_trans",
      docs: [
        source_ref: "v#{@version}",
        main: "Cldr Trans"
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      # {:ex_cldr, "~> 2.27"},
      {:ex_cldr, path: "../cldr"},
      {:jason, "~> 1.1"},
      {:ecto, "~> 3.0"},

      # Optional dependencies
      {:ecto_sql, "~> 3.0", optional: true},
      {:postgrex, "~> 0.14", optional: true},

      # Doc dependencies
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false, optional: true},
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Cristian Álvarez Belaustegui", "Kip Cole"],
      links: %{"GitHub" => "https://github.com/elixir-cldr/cldr_trans"}
    ]
  end

  # Include Ecto and Postgrex applications in tests
  def app_list(:test), do: [:ecto, :postgrex]
  def app_list(_), do: app_list()
  def app_list, do: []

  # Always compile files in "lib". In tests compile also files in
  # "test/support"
  def elixirc_paths(:test), do: elixirc_paths() ++ ["mix", "test/support"]
  def elixirc_paths(:dev), do: elixirc_paths() ++ ["mix"]
  def elixirc_paths(_), do: elixirc_paths()
  def elixirc_paths, do: ["lib"]

  defp aliases do
    [
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test"
      ]
    ]
  end
end