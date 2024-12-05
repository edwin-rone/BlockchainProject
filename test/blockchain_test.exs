defmodule BlockchainTest do
  use ExUnit.Case
  alias Blockchain

  test "crear una blockchain inicial" do
    blockchain = Blockchain.new()
    assert length(blockchain.blocks) == 1 # Bloque génesis
  end

  test "insertar bloques válidos en la blockchain" do
    blockchain = Blockchain.new()
    {:ok, blockchain} = Blockchain.insert(blockchain, %{data: "Bloque 1"})
    {:ok, blockchain} = Blockchain.insert(blockchain, %{data: "Bloque 2"})
    assert length(blockchain.blocks) == 3
    assert Blockchain.valid?(blockchain)
  end

  test "rechazar bloques inválidos" do
    blockchain = Blockchain.new()
    {:error, _} = Blockchain.insert(blockchain, nil)
    assert length(blockchain.blocks) == 1
    assert Blockchain.valid?(blockchain)
  end
end

