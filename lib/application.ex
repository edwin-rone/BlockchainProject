defmodule BlockchainProject.Application do
  use Application

  def start(_type, _args) do
    children = [
     {P2PNetwork, []}
    ]

    opts = [strategy: :one_for_one, name: BlockchainProject.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

