defmodule PyrlangpocWeb.MessageChannel do
  use PyrlangpocWeb, :channel
  alias PyrlangpocWeb.MessageController

  @impl true
  def join("room:" <> _room, _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("message", payload, socket) do
    "room:" <> _room_name = socket.topic

    %{"script" => script, "strategy" => strategy} = payload

    uuid = MessageController.push_to_stack(script, strategy)

    broadcast(socket, "message", %{uuid: uuid, strategy: strategy, script: script})
    {:noreply, socket}
  end

  @impl true
  def handle_in("user_input", payload, socket) do
    "room:" <> _room_name = socket.topic

    %{"input" => input, "uuid" => uuid} = payload
    response = MessageController.get_response(input, uuid)
    broadcast(socket, "user_input", response)
    {:noreply, socket}
  end
end
