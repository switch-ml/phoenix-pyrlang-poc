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

    def run(self):
        self.socket.on_open = self.connect
        connection = self.socket.connect(blocking=False)
        connection.wait()


if __name__ == "__main__":

    parser = argparse.ArgumentParser()

    parser.add_argument("--strategy", "-s", help="User Value")
    parser.add_argument("--file", "-f", help="File Path")

    args = parser.parse_args()

    print(args.strategy)

    strategy = args.strategy
    file = args.file

    script = None

    with open(file, "r") as f:
        script = "".join(f.readlines())

    if strategy and script:
        URL = "ws://localhost:4000/socket/websocket"
        c = CustomSocket(URL, "room:general")
        c.run()
        c.channel.push("create",
                       {"script": script, "strategy": strategy})

        x = True
    while not x:
        time.sleep(0.1)
