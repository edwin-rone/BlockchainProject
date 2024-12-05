defmodule BlockTest do
  use ExUnit.Case

  test "Block creation and validation create a valid block" do
    block = Block.new("Test", "previous_hash_example")
    assert block.data == "Test"
    assert block.prev_hash == "previous_hash_example"
  end

  test "Block creation and validation validate a valid block" do
    block = Block.new("Test", "previous_hash_example")
    assert Block.valid?(block)
  end

  test "Block creation and validation invalidate a tampered block" do
    block = Block.new("Test", "previous_hash_example")
    tampered_block = %{block | data: "Tampered"}
    refute Block.valid?(tampered_block)
  end
end
