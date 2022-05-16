defmodule PyrlangpocWeb.MessageController do
  use PyrlangpocWeb, :controller
  # use GenServer
  alias Pyrlangpoc.Stack

  def push_to_stack(script, strategy) do
    uuid = UUID.uuid4(:hex)
    data = %{script: script, strategy: strategy}

    Stack.put(uuid, data)
    Stack.put(strategy, Stack.get(strategy))
    uuid
  end

  def create(conn, payload) do
    file = Map.get(payload, "file")
    strategy = Map.get(payload, "strategy")

    script =
      if file do
        {:ok, file_binary} = File.read(file.path)
        file_binary
      else
        Map.get(payload, "script")
      end

    uuid = push_to_stack(script, strategy)

    json(
      conn,
      uuid
    )
  end

  def get_response(input, uuid) do
    message = Stack.get(uuid)
    strategy = Map.get(message, "strategy")

    oldvalue = Stack.get(strategy)

    message = Map.put(message, :input, input)
    message = Map.put(message, :oldvalue, oldvalue)

    my_process = {:my_process, :"py@127.0.0.1"}
    res = GenServer.call(my_process, Poison.encode!(message))

    response = Poison.Parser.parse!(res)

    if Map.get(response, "stdout") != "" do
      Stack.put(strategy, Map.get(response, "stdout"))
    end

    response
  end

  def execute(conn, payload) do
    uuid = Map.get(payload, "uuid")
    input = Map.get(payload, "input")

    response = get_response(input, uuid)

    json(
      conn,
      response
    )
  end
end
