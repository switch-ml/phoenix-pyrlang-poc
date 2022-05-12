from pyrlang.node import Node
from term import Atom


async def example_main(node):
    fake_pid = node.register_new_process()

    # To be able to send to Erlang shell by name first give it a registered
    # name: `erlang:register(shell, self()).`
    # To see an incoming message in shell: `flush().`
    await node.send(
        sender=fake_pid,
        receiver=(Atom("venkatesh@127.0.0.1"), Atom("shell")),
        message=Atom("hello"),
    )


def main():
    node = Node(node_name="py@127.0.0.1", cookie="secret")
    ev = node.get_loop()
    ev.create_task(example_main(node))
    node.run()


if __name__ == "__main__":
    main()
