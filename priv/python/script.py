from erlport.erlterms import Atom
from erlport.erlang import set_message_handler, cast
import random


def generate_random_numbers(count):
    # Generate count(5) number of random numbers between 1 and 100
    randomlist = random.sample(range(1, 100), count)
    return randomlist


message_handler = None  # reference to the elixir process to send result to


def cast_message(pid, message):
    cast(pid, message)


def register_handler(pid):
    # save message handler pid
    global message_handler
    message_handler = pid


def handle_message(count):
    try:
        print("Received message from Elixir")
        print(count)
        result = generate_random_numbers(count)
        if message_handler:
            # build a tuple to atom {:python, result}
            cast_message(message_handler, (Atom('python'), result))
    except Exception as e:
        # you can send error to elixir process here too
        # print e
        pass


# set handle_message to receive all messages sent to this python instance
set_message_handler(handle_message)
