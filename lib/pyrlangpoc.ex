defmodule Pyrlangpoc do
  @moduledoc """
  Pyrlangpoc keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use GenServer
  alias Pyrlangpoc.Helper

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_args) do
    # start the python session and keep pid in state
    python_session = Helper.start()
    # register this process as the message handler
    Helper.call(python_session, :script, :register_handler, [self()])
    {:ok, python_session}
  end

  def cast_count(count) do
    {:ok, pid} = start_link()
    GenServer.cast(pid, {:count, count})
  end

  def call_count(count) do
    {:ok, pid} = start_link()
    # :infinity timeout only for demo purposes
    GenServer.call(pid, {:count, count}, :infinity)
  end

  def handle_call({:count, count}, _from, session) do
    result = Helper.call(session, :script, :generate_random_numbers, [count])
    {:reply, result, session}
  end

  def handle_cast({:count, count}, session) do
    Helper.cast(session, count)
    {:noreply, session}
  end

  def handle_info({:python, message}, session) do
    IO.puts("Received message from python: #{inspect(message)}")

    # stop elixir process
    {:stop, :normal, session}
  end

  def terminate(_reason, session) do
    Helper.stop(session)
    :ok
  end
end
