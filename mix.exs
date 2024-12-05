defmodule BlockchainProject.MixProject do
  use Mix.Project

  def project do
    [
      app: :blockchain_project,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto], # Incluye :crypto aquí
      mod: {BlockchainProject.Application, []} # Asegúrate de que este módulo exista
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end
end

