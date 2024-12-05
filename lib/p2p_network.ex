defmodule P2PNetwork do
  def main do
    n = 10  # Número de nodos
    k = 6   # Grado de cada nodo
    p = 0.1  # Probabilidad de reordenar las conexiones

    IO.puts("Generando red con #{n} nodos, #{k} conexiones iniciales y p=#{p}")
    network = NetworkTopology.generate_network(n, k, p)

    IO.puts("Número de nodos: #{length(network.nodes)}")
    IO.puts("Número de conexiones: #{length(network.edges)}")

    coefficient = NetworkTopology.clustering_coefficient(network)

    IO.puts("Coeficiente de agrupamiento promedio: #{coefficient}")

    if coefficient > 0.4 do
      IO.puts("La red cumple con el coeficiente de agrupamiento.")
    else
      IO.puts("La red no cumple con el coeficiente de agrupamiento.")
    end

    # Iniciar consenso para cada nodo
    Enum.each(network.nodes, fn node ->
      start_consensus(node, network)
    end)
  end

  # Iniciar el proceso de consenso para un nodo
  def start_consensus(node, network) do
    neighbors = NetworkTopology.neighbors(network, node)
    IO.puts("Iniciando consenso para el nodo #{node} con vecinos: #{inspect(neighbors)}")

    Enum.each(neighbors, fn neighbor ->
      IO.puts("Nodo #{node} envía PREPARE al vecino #{neighbor}")
      IO.puts("Vecino #{neighbor} responde COMMIT a nodo #{node}")
    end)
  end
end
