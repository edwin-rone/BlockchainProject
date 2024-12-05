defmodule P2PNetworkTest do
  use ExUnit.Case
  alias P2PNetwork

  test "crear red con nodos" do
    P2PNetwork.start_link([])
    P2PNetwork.create_network(5, 1)
    state = :sys.get_state(P2PNetwork)
    assert map_size(state.nodes) == 5
  end

  test "verificar topología de red" do
    P2PNetwork.start_link([])
    P2PNetwork.create_network(6, 1)
    state = :sys.get_state(P2PNetwork)
    Enum.each(state.nodes, fn {_id, node} ->
      assert length(node.neighbors) > 0
    end)
  end

  test "propagar mensajes entre nodos" do
    P2PNetwork.start_link([])
    P2PNetwork.create_network(4, 0)
    P2PNetwork.send_message(1, {:test_message, "Hola"})
    state = P2PNetwork.get_node_state(1)
    assert Enum.any?(state.messages, fn msg -> msg == {:test_message, "Hola"} end)
  end
end


