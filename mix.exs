defmodule Fauxpets.MixProject do
  use Mix.Project

  def project do
    [
      app: :fauxpets,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Fauxpets.Application, []}
    ]
  end

  def model_path(from_git?) do
    if from_git? do
      {:fauxpets_model, git: "https://github.com/iikorni/fauxpets_model"}
    else
      {:fauxpets_model, path: "../fauxpets_model"}
    end
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ranch, "~> 2.0"},
      {:remix, "~> 0.0.1", only: :dev},
      model_path(false)
    ]
  end
end
