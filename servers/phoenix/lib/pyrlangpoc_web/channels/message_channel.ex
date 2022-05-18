defmodule PyrlangpocWeb.MessageChannel do
  use PyrlangpocWeb, :channel

  alias Pyrlangpoc.Stack

  def push_to_stack(script, strategy) do
    state = Stack.get(:state)
    Stack.put(strategy, %{script: script, state: state})
  end

  def get_from_stack(input, strategy) do
    message = Stack.get(strategy)

    my_process = {:my_process, :"py@127.0.0.1"}

    res =
      GenServer.call(
        my_process,
        Jason.encode!(%{input: input, oldvalue: message[:state], script: message[:script]})
      )

    response = Jason.decode!(res)

    if Map.get(response, "stdout") != "" do
      Stack.put(strategy, %{script: message[:script],state: Map.get(response, "stdout")})
    end

    response
  end

  @impl true
  def join("room:" <> _room, _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("create", payload, socket) do
    %{"script" => script, "strategy" => strategy} = payload
    push_to_stack(script, strategy)
    {:noreply, socket}
  end

  @impl true
  def handle_in("execute", payload, socket) do
    %{"input" => input, "strategy" => strategy} = payload
    response = get_from_stack(input, strategy)
    broadcast(socket, "execute", response)
    {:noreply, socket}
  end
end
