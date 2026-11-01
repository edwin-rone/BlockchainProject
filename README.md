# Blockchain distribuida con consenso PBFT — Elixir

Simulación de una blockchain sobre una red peer-to-peer, en la que los nodos se ponen de acuerdo sobre cada bloque con el protocolo de consenso **PBFT (Practical Byzantine Fault Tolerance)**. Proyecto final de Computación Distribuida (Facultad de Ciencias, UNAM).

## Tecnologías

- Elixir / OTP (GenServer, Registry)
- `:crypto` para el hash de los bloques
- ExUnit para pruebas

## Qué hace

- **Blockchain**: bloques encadenados por hash, con un bloque génesis y validación de la integridad de la cadena.
- **Topología de red**: genera la red de nodos con el modelo de mundo pequeño **Watts–Strogatz**.
- **Red P2P**: cada nodo es un proceso independiente que se comunica por mensajes con sus vecinos.
- **Consenso PBFT**: los nodos pasan por las fases *pre-prepare → prepare → commit* y solo agregan un bloque cuando se alcanza un quórum de 2f + 1, tolerando hasta f nodos con fallas bizantinas.

## Estructura

| Módulo | Responsabilidad |
| --- | --- |
| `block.ex` | Creación y validación de bloques |
| `blockchain.ex` | Cadena de bloques y verificación de integridad |
| `network_topology.ex` | Generación de la red (Watts–Strogatz) |
| `p2p_network.ex` | Creación de nodos y envío de mensajes |
| `pbft.ex` | Máquina de estados del consenso PBFT |
| `main.ex` | Arranque de la red y simulación de una transacción |

## Cómo ejecutarlo

```bash
mix deps.get
mix test          # corre las pruebas
iex -S mix        # consola interactiva
```

Dentro de la consola: `Main.run()`

## Equipo

- Juan Luis Legorreta Esparragoza
- Víctor Manuel Mendiola Montes
- Edwin Rodríguez Nevárez
