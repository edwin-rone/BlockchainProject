defmodule P2pNetworkTest do
  use ExUnit.Case
  doctest P2pNetwork

  test "greets the world" do
    assert P2pNetwork.hello() == :world
  end
end
