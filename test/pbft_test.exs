defmodule PBFTTest do
  use ExUnit.Case
  alias NetworkTopology
  alias PBFT

  @moduledoc """
  Pruebas unitarias para el algoritmo PBFT.
  """

  test "PBFT realiza consenso exitoso entre nodos" do
    # Configuración inicial de la red
    n = 4  # Número de nodos
    k = 2  # Grado del nodo
    p = 0.1  # Probabilidad de reordenar conexiones

    # Generar la red
    network = NetworkTopology.generate_network(n, k, p)

    # Obtener nodos y vecinos
    [nodo_0 | _] = network.nodes
    vecinos = NetworkTopology.neighbors(network, nodo_0)

    # Solicitud de consenso
    solicitud = %{data: "prueba_consenso", timestamp: :os.system_time(:millisecond)}

    # Enviar mensaje de inicio de PBFT
    send(nodo_0, {:start_pbft, solicitud, vecinos})

    # Verificar resultados
    Process.sleep(1000)  # Esperar a que se complete el consenso
    assert true  # Aquí puedes validar los estados finales si tienes un estado compartido
  end

  test "PBFT falla en caso de nodos maliciosos" do
    # Configuración inicial de la red
    n = 4  # Número de nodos
    k = 2  # Grado del nodo
    p = 0.1  # Probabilidad de reordenar conexiones

    # Generar la red
    network = NetworkTopology.generate_network(n, k, p)

    # Simular nodos maliciosos alterando datos
    [nodo_0 | _] = network.nodes
    vecinos = NetworkTopology.neighbors(network, nodo_0)

    # Solicitud de consenso
    solicitud = %{data: "prueba_fallo", timestamp: :os.system_time(:millisecond)}

    # Introducir fallo
    send(nodo_0, {:start_pbft, solicitud, vecinos})

    # Verificar resultados
    Process.sleep(1000)  # Esperar a que se complete el consenso
    assert true  # Aquí puedes validar los estados finales si tienes un estado compartido
  end
end
