defmodule PBFT do
  use GenServer

  # Estado inicial del nodo
  defstruct [
    :id,               # Identificador único del nodo
    :neighbors,        # Lista de nodos vecinos
    :messages,         # Mensajes recibidos
    :state,            # Estado actual del nodo (:idle, :pre_prepare, :prepare, :commit)
    :current_block,    # Bloque en proceso de consenso
    :prepared_blocks   # Bloques validados para ser añadidos
  ]

  ## API pública
  # Iniciar el nodo PBFT
  def start_link(id, neighbors) do
    GenServer.start_link(__MODULE__, %PBFT{
      id: id,
      neighbors: neighbors,
      messages: [],
      state: :idle,
      current_block: nil,
      prepared_blocks: []
    }, name: via_tuple(id))
  end

  # Enviar un mensaje a otro nodo
  def send_message(target_id, message) do
    GenServer.cast(via_tuple(target_id), {:receive_message, message})
  end

  # Obtener el estado actual del nodo
  def get_state(node_id) do
    GenServer.call(via_tuple(node_id), :get_state)
  end

  # Via tuple para registrar nodos en el sistema
  defp via_tuple(id), do: {:via, Registry, {PBFTRegistry, id}}

  ## Callbacks de GenServer
  @impl true
  def init(initial_state), do: {:ok, initial_state}

  @impl true
  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  @impl true
  def handle_cast({:receive_message, message}, state) do
    new_state = process_message(message, state)
    {:noreply, new_state}
  end

  ## Lógica principal del PBFT
  # Procesar los mensajes según la fase del protocolo
  defp process_message({:pre_prepare, block}, state) do
    # Verificar y pasar a la fase Prepare
    if state.state == :idle do
      broadcast(:prepare, block, state.neighbors, state.id)
      %{state | state: :prepare, current_block: block}
    else
      state
    end
  end

  defp process_message({:prepare, block}, state) do
    # Validar y recopilar quórum para pasar a Commit
    if state.state == :prepare do
      new_messages = [block | state.messages]
      if quorum_reached?(new_messages, block) do
        broadcast(:commit, block, state.neighbors, state.id)
        %{state | state: :commit, messages: new_messages}
      else
        %{state | messages: new_messages}
      end
    else
      state
    end
  end

  defp process_message({:commit, block}, state) do
    # Confirmar el bloque y añadirlo a la blockchain
    if state.state == :commit do
      new_blocks = [block | state.prepared_blocks]
      %{state | state: :idle, prepared_blocks: new_blocks, current_block: nil}
    else
      state
    end
  end

  defp process_message(_, state), do: state

  ## Funciones auxiliares
  # Difundir un mensaje a los vecinos
  defp broadcast(phase, block, neighbors, sender_id) do
    Enum.each(neighbors, fn neighbor ->
      send_message(neighbor, {phase, block, sender_id})
    end)
  end

  # Verificar si se alcanzó el quórum para la fase actual
  defp quorum_reached?(messages, block) do
    count = Enum.count(messages, fn msg -> msg == block end)
    count >= required_quorum(length(messages))
  end
  
  def start_consensus(node_id, neighbors, block) do
    Enum.each(neighbors, fn neighbor ->
      IO.puts("Nodo #{node_id} envía PRE-PREPARE a #{neighbor}")
    end)
  end

  defp send_pre_prepare(node_id, neighbors, block) do
    Enum.each(neighbors, fn neighbor ->
      # Simula enviar el mensaje Pre-Prepare
      IO.puts("Nodo #{node_id} envía Pre-Prepare a #{neighbor} con bloque: #{inspect(block)}")
    end)
  end

  # Calcular el quórum requerido
  defp required_quorum(n), do: div(n, 3) * 2 + 1
end

