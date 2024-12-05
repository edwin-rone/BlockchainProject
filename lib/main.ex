defmodule Main do
  @moduledoc """
  Manejador principal del sistema de blockchain con PBFT.
  """

  def start_network(n, f) do
    # Inicia el sistema de nodos con n nodos y f nodos maliciosos
    {:ok, _pid} = P2PNetwork.start_link([])
    P2PNetwork.create_network(n, f)
  end

  def simulate_consensus(transaction) do
    # Enviar una transacción al primer nodo
    IO.puts("Simulando consenso para la transacción: #{inspect(transaction)}")

    # Selecciona un nodo inicial para iniciar el proceso
    P2PNetwork.send_message(0, {:pre_prepare, transaction})

    # Monitorea el estado de los nodos
    :timer.sleep(2000) # Esperar para que los nodos intercambien mensajes

    IO.puts("Estado de los nodos después del consenso:")
    Enum.each(0..9, fn id ->
      IO.inspect(P2PNetwork.get_node_state(id))
    end)
  end

  def run() do
    # Configuración inicial
    n = 10  # Número de nodos
    f = 2   # Nodos maliciosos

    IO.puts("Iniciando la red con #{n} nodos y #{f} nodos maliciosos...")
    start_network(n, f)

    # Transacción de prueba
    transaction = %{data: "Transferencia de 10 monedas"}
    simulate_consensus(transaction)
  end
end

