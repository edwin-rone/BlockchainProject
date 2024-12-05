defmodule PBFT do
  @moduledoc """
  Implementación del algoritmo de consenso Practical Byzantine Fault Tolerance (PBFT).
  """

  # Inicia el consenso en un nodo primario
  def start_consensus(primary_node, block, nodes) do
    send_prepare(block, nodes)
  end

  # Fase PREPARE: Enviar preparación a los nodos
  defp send_prepare(block, nodes) do
    Enum.each(nodes, fn node ->
      send(node, {:prepare, block})
    end)
  end

  # Fase COMMIT: Confirmar consenso
  defp send_commit(block, nodes) do
    Enum.each(nodes, fn node ->
      send(node, {:commit, block})
    end)
  end

  # Manejo de mensajes en cada nodo
  def handle_message(:prepare, block, state) do
    IO.puts("Nodo #{self()} recibió PREPARE para el bloque: #{inspect(block)}")
    {:ok, state}
  end

  def handle_message(:commit, block, state) do
    IO.puts("Nodo #{self()} recibió COMMIT para el bloque: #{inspect(block)}")
    {:ok, state}
  end
end
