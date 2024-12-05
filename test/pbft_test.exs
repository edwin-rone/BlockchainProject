defmodule PBFTTest do
  use ExUnit.Case
  alias PBFT

  setup do
    {:ok, _} = Registry.start_link(keys: :unique, name: PBFTRegistry)
    :ok
  end

  test "procesar fases de consenso correctamente" do
    {:ok, _pid} = PBFT.start_link(1, [2, 3])
    block = %{data: "Bloque de prueba"}
    PBFT.send_message(1, {:pre_prepare, block})
    state = PBFT.get_state(1)
    assert state.state == :prepare
  end
end

