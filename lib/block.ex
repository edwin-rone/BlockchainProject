defmodule Block do
  @moduledoc """
  Representa un bloque en una blockchain.
  """

  @enforce_keys [:data, :timestamp, :prev_hash, :hash]
  defstruct [:data, :timestamp, :prev_hash, :hash]

  @doc """
  Crea un nuevo bloque dado los datos y el hash del bloque anterior.
  """
  def new(data, prev_hash) do
    timestamp = :os.system_time(:millisecond)
    hash = compute_hash(data, timestamp, prev_hash)

    %Block{
      data: data,
      timestamp: timestamp,
      prev_hash: prev_hash,
      hash: hash
    }
  end

  @doc """
  Valida si un bloque es consistente (si su hash coincide con sus datos).
  """
  def valid?(%Block{data: data, timestamp: timestamp, prev_hash: prev_hash, hash: hash}) do
    hash == compute_hash(data, timestamp, prev_hash)
  end

  @doc """
  Valida si dos bloques consecutivos son válidos.
  """
  def valid?(%Block{} = prev_block, %Block{} = current_block) do
    current_block.prev_hash == prev_block.hash and valid?(current_block)
  end

  @doc """
  Calcula el hash de un bloque a partir de sus datos, timestamp y hash previo.
  """
  defp compute_hash(data, timestamp, prev_hash) do
    :crypto.hash(:sha256, "#{data}#{timestamp}#{prev_hash}")
    |> Base.encode16(case: :lower)
  end
end
