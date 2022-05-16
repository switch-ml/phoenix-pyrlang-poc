import json
from term import Atom
from pyrlang.gen.server import GenServer
from pyrlang.gen.decorators import call
from pyrlang import Node
import epicbox
import ast


class MyProcess(GenServer):
    def __init__(self, node) -> None:
        super().__init__()
        node.register_name(self, Atom("my_process"))

    @call(1, lambda msg: True)
    def hello_catch_all(self, msg):
        """Catch all handler"""
        data = json.loads(msg.decode())
        script = data.get("script")
        input = data.get("input")
        input = ast.literal_eval(input)

        oldvalue = data.get("oldvalue", None)

        main_script = """import argparse
import ast

parser = argparse.ArgumentParser()

parser.add_argument("--input", "-i", help="User Value")

args = parser.parse_args()

input = ast.literal_eval(args.input)

{script}

""".format(script=script)

        if oldvalue:
            oldvalue = ast.literal_eval(oldvalue)
            input = [input, oldvalue]
        else:
            input = [input]

        file_data = {
            "name": "main.py",
            "content": main_script.encode(),
        }
        limits = {"cputime": 1, "memory": 64}

        profiles = {
            "python": {
                "docker_image": "ml_ml-poc:latest",
            }
        }

        # docker composed image
        epicbox.configure(profiles=profiles)

        cmd = f"python3 {file_data.get('name')} --input '{input}'"

        result = epicbox.run(
            "python",
            cmd,
            files=[file_data],
            limits=limits,
        )
        # convert binary data to string
        result["stdout"] = result["stdout"].decode("utf-8").strip("\n")
        result["stderr"] = result["stderr"].decode("utf-8")

        return json.dumps(result)


def main():
    node = Node(node_name="py@127.0.0.1", cookie="secret")

    MyProcess(node)

    node.run()


if __name__ == "__main__":
    main()
