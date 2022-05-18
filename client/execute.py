import phxsocket
import time

import argparse
import ast


x = False


class CustomSocket:
    def __init__(self, URL, topic) -> None:
        self.url = URL
        self.socket = phxsocket.Client(self.url)
        self.topic = topic
        self.channel = None
        self.closed = True

    def connect(self, socket):
        self.channel = socket.channel(self.topic, {})
        self.channel.join()

        self.channel.on("execute", self.on_response)

    def run(self):
        self.socket.on_open = self.connect
        connection = self.socket.connect(blocking=False)
        connection.wait()

    def on_response(self, payload):
        print(f"Response: {payload}")
        global x
        x = True


if __name__ == "__main__":

    parser = argparse.ArgumentParser()

    parser.add_argument("--strategy", "-s", help="User Value")
    parser.add_argument("--input", "-i", help="Input for script")

    args = parser.parse_args()

    strategy = args.strategy
    user_input = args.input

    URL = "ws://localhost:4000/socket/websocket"
    c = CustomSocket(URL, "room:general")
    c.run()
    c.channel.push("execute", {"input": user_input, "strategy": strategy})

    while not x:
        time.sleep(0.1)
