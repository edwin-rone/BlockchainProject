defmodule NetworkTopology do
  @moduledoc """
  Genera una red de nodos usando el modelo Watts-Strogatz con procesos enlazados.
  """

  def generate_network(n, k, p) when rem(k, 2) == 0 do
    nodes = Enum.map(0..(n - 1), fn id -> spawn_link(fn -> node_process(id) end) end)
    initial_edges = create_regular_ring(nodes, k)
    rewired_edges = rewire_edges(initial_edges, p, nodes)

    %{nodes: nodes, edges: rewired_edges}
  end

  defp create_regular_ring(nodes, k) do
    Enum.reduce(0..(length(nodes) - 1), [], fn node, acc ->
      range_limit = div(k, 2)
      neighbors =
        1..range_limit
        |> Enum.map(fn i -> rem(node + i, length(nodes)) end)

      acc ++ Enum.map(neighbors, fn neighbor -> {Enum.at(nodes, node), Enum.at(nodes, neighbor)} end)
    end)
  end

  defp rewire_edges(edges, p, nodes) do
    Enum.map(edges, fn {node, neighbor} ->
      if :rand.uniform() < p do
        available_nodes = nodes -- [node, neighbor]
        if available_nodes != [] do
          new_neighbor = Enum.random(available_nodes)
          {node, new_neighbor}
        else
          {node, neighbor}
        end
      else
        {node, neighbor}
      end
    end)
  end
  
    def watts_strogatz(nodes, k, p) do
    Enum.map(0..(nodes - 1), fn id ->
      neighbors = for i <- 1..k, do: rem(id + i, nodes)
      {id, neighbors}
    end)
    |> Enum.into(%{})
  end

  def node_process(node_id) do
    receive do
      {:start_pbft, request, neighbors} ->
        IO.puts("Nodo #{node_id} inicia PBFT para: #{inspect(request)}")
        PBFT.start_consensus(request, node_id, neighbors)
        node_process(node_id)

      {:message, content} ->
        IO.puts("Nodo #{node_id} recibió mensaje: #{inspect(content)}")
        node_process(node_id)
    after
      10_000 ->
        IO.puts("Nodo #{node_id} está inactivo.")
    end
  end
end
