defmodule Pyrlangpoc.Observer do
  @moduledoc """
  Simple process that monitors node changes in the
  current cluster.
  """

  use GenServer

  require Logger

  def start_link(_), do: GenServer.start_link(__MODULE__, Map.new())

  @impl GenServer
  def init(state) do
    :net_kernel.monitor_nodes(true)
    # receiver_listener()
    {:ok, state}
  end

  def receiver_listener do
    receive do
      {:shell, value, sender} ->
        IO.puts(value)
        IO.puts(sender)
    end
  end

  @impl GenServer
  def handle_info({:nodedown, node}, state) do
    # A node left the cluster
    Logger.info("--- Node down: #{node}\n")

    {:noreply, state}
  end

  def handle_info({:nodeup, node}, state) do
    # A new node joined the cluster
    Logger.info("--- Node up: #{node}\n")
    Logger.info("---- state: #{state}")

    {:noreply, state}
  end
end
