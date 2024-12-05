defmodule P2PNetwork do
  use GenServer

  @moduledoc """
  Maneja la creación y comunicación de nodos en una red peer-to-peer.
  """

  ## API Pública

  # Inicia la red con n nodos y una topología definida
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end
  
  def init(state) do
    {:ok, state}
  end

  # Crear la red con n nodos y f nodos maliciosos
  def create_network(n, f) do
    GenServer.call(__MODULE__, {:create_network, n, f})
  end
  
  def send_message(target_id, message) do
    GenServer.cast({:via, Registry, {PBFTRegistry, target_id}}, {:message, message})
  end

  # Enviar un mensaje a un nodo específico
  def send_message(node_id, message) do
    PBFT.send_message(node_id, message)
  end

  # Obtener el estado de un nodo
  def get_node_state(node_id) do
    PBFT.get_state(node_id)
  end

  ## Callbacks de GenServer

  @impl true
  def init(_args) do
    {:ok, %{nodes: %{}, topology: nil}}
  end

  @impl true
  def handle_call({:create_network, n, f}, _from, state) do
    topology = NetworkTopology.watts_strogatz(n, 2, 0.1)
    {:reply, :ok, Map.put(state, :topology, topology)}
  end
  ## Funciones auxiliares

  # Crear nodos con PBFT
  defp create_nodes(n, f, topology) do
    Enum.reduce(0..(n - 1), %{}, fn id, acc ->
      neighbors = Map.get(topology, id, [])
      is_malicious = id < f

      # Iniciar nodo PBFT con comportamiento malicioso u honesto
      {:ok, _pid} =
        PBFT.start_link(id, neighbors)

      Map.put(acc, id, %{id: id, neighbors: neighbors, malicious: is_malicious})
    end)
  end

  # Generar topología de Watts-Strogatz
  defp generate_topology(n) do
    NetworkTopology.watts_strogatz(n, 4, 0.5)
  end
end

