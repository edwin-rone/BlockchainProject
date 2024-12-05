defmodule BlockTest do
  use ExUnit.Case
  alias Block

  test "crear un bloque válido" do
    block = Block.new(%{data: "Transacción 1"}, "prev_hash")
    assert block.data == %{data: "Transacción 1"}
    assert block.prev_hash == "prev_hash"
    assert block.hash != nil
  end

  test "validar un bloque individual" do
    block = Block.new(%{data: "Transacción 1"}, "prev_hash")
    assert Block.valid?(block)
  end

  test "validar dos bloques consecutivos" do
    block1 = Block.new(%{data: "Bloque 1"}, "prev_hash")
    block2 = Block.new(%{data: "Bloque 2"}, block1.hash)
    assert Block.valid?(block1, block2)
  end
end

