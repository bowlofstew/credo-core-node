defmodule CredoCoreNode.Workers.GarbageCollector do
  use GenServer

  require Logger

  import Process, only: [send_after: 3]

  alias CredoCoreNode.{Blockchain, Pool}

  def start_link(interval \\ 60_000) do
    GenServer.start_link(__MODULE__, interval, name: __MODULE__)
  end

  def init(interval) do
    Logger.info("Initializing the garbage collector...")

    handle_info(:collect_garbage, interval)

    {:ok, interval}
  end

  def handle_info(:collect_garbage, interval) do
    schedule_collect_garbage(interval)

    Pool.list_pending_blocks()
    |> Enum.filter(&(&1.number < Blockchain.last_irreversible_block_number()))
    |> Enum.each(fn block -> Pool.delete_pending_block(block) end)

    {:noreply, interval}
  end

  defp schedule_collect_garbage(interval) do
    send_after(self(), :collect_garbage, interval)
  end
end