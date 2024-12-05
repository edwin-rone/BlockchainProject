defmodule BlockchainTest do
  use ExUnit.Case
  alias Blockchain

  describe "Blockchain" do
    test "crea una blockchain con un bloque génesis" do
      chain = Blockchain.new()
      assert length(chain) == 1
      assert hd(chain).data == "Génesis"
    end

    test "añade un nuevo bloque a la blockchain" do
      chain = Blockchain.new()
      chain = Blockchain.add_block(chain, "Primer bloque")
      assert length(chain) == 2
      assert List.last(chain).data == "Primer bloque"
    end

    test "valida una blockchain válida" do
      chain = Blockchain.new()
      chain = Blockchain.add_block(chain, "Primer bloque")
      chain = Blockchain.add_block(chain, "Segundo bloque")
      assert Blockchain.valid?(chain)
    end

    test "detecta una blockchain inválida" do
      chain = Blockchain.new()
      chain = Blockchain.add_block(chain, "Primer bloque")
      # Introducir inconsistencia en la cadena
      tampered_chain = List.replace_at(chain, 1, %{List.last(chain) | data: "Manipulado"})
      refute Blockchain.valid?(tampered_chain)
    end
  end
end
