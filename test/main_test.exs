defmodule MainTest do
  use ExUnit.Case
  alias Main

  test "inicialización de la red y simulación de consenso" do
    # Inicializar la red
    Main.start_network(5, 1)  # 5 nodos, 1 malicioso

    # Simular una transacción
    transaction = %{data: "Transacción de prueba"}
    Main.simulate_consensus(transaction)

    # Verificar estados de los nodos
    for id <- 0..4 do
      state = P2PNetwork.get_node_state(id)
      assert state.current_block == nil
      assert length(state.prepared_blocks) == 1
    end
  end
end

