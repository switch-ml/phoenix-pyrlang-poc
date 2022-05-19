# phoenix-pyrlang-poc

## Clone the repository

```
- git clone https://github.com/f-inverse/phoenix-pyrlang-poc
- cd phoenix-pyrlang-poc
- git checkout dev/venkatesh
```

## Install the dependencies and start the servers

1. Terminal-1: Phoenix Server

   ```
   - mix deps.get
   - elixir --name erl@127.0.0.1 --cookie secret -S mix phx.server
   ```

2. Terminal-2: Python Pyrlang Server

   - if python3 installed as python use python else use python3

   ```
   - create virtual environment
   - python -m venv venv
   - source venv/bin/activate
   - pip install -r requirements.txt
   - python server.py
   ```

3. Terminal-2: Python Client Server

   - if python3 installed as python use python else use python3

   ```
   - create virtual environment
   - python -m venv venv
   - source venv/bin/activate
   - pip install -r requirements.txt
   ```

   A. Create Strategy

   ```
   - python create.py --strategy mean --file <path_to_file>
   ```

   B. Execute Strategy

   ```
   - python execute.py --strategy mean --input "[1,2,3]"
   ```
