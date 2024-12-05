defmodule Blockchain do
  @moduledoc """
  Representa una cadena de bloques. Proporciona funciones para añadir bloques,
  validar la integridad de la cadena y gestionar su estado.
  """

  alias Block

  defstruct [:blocks]

  def new() do
    %Blockchain{blocks: [%Block{data: "Genesis", prev_hash: "", hash: "GENESIS"}]}
  end
  
  def insert(%Blockchain{blocks: blocks} = chain, data) do
    last_block = List.last(blocks)
    new_block = Block.new(data, last_block.hash)

    if Block.valid?(last_block, new_block) do
      {:ok, %Blockchain{blocks: blocks ++ [new_block]}}
    else
      {:error, :invalid_block}
    end
  end
  
  def valid?(%Blockchain{blocks: blocks}) do
    Enum.chunk_every(blocks, 2, 1, :discard)
    |> Enum.all?(fn [a, b] -> Block.valid?(a, b) end)
  end
  
  @doc """
  Inicializa una nueva blockchain con un bloque génesis.
  """
  def new(data \\ "Génesis") do
    genesis_block = Block.new(data, "0")
    [genesis_block]
  end

  @doc """
  Añade un nuevo bloque a la blockchain.
  """
  def add_block(chain, data) do
    last_block = List.last(chain)
    new_block = Block.new(data, last_block.hash)
    chain ++ [new_block]
  end

  @doc """
  Valida la integridad de toda la blockchain.
  """
  def valid?(chain) do
    chain
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [prev_block, current_block] -> Block.valid?(prev_block, current_block) end)
  end
end
