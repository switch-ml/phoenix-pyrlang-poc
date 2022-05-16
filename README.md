# phoenix-pyrlang-poc

## Clone the repository

```
- git clone https://github.com/f-inverse/phoenix-pyrlang-poc
- cd phoenix-pyrlang-poc
- git checkout dev/venkatesh
```

## Install the dependencies

1. Terminal-1: Phoenix Server

   ```
   - mix setup
   - elixir --name erl@127.0.0.1 --cookie secret -S mix phx.server
   ```

2. Terminal-2: Python Pyrlang Server

   - if python3 installed as python use python else use python3

   ```
   - create virtual environment
   - python -m venv venv
   - source venv/bin/activat
   - pip install -r requirements.txt
   - python server.py
   ```

3. Build Python Docker Image

   ```
   - cd ml
   - docker-compose build
   ```

## Routes

1. Create Strategy

   ```
   Request Method: POST
   URL: http://localhost:4000/api/strategy/create
   payload:`{ "script": "print('Hello Venkatesh...!!')", "strategy": "custom" }`

   ```

   - if we want to upload file use form data and upload file with key `file` and `strategy=<your_value>`

2. Execte Strategy

   ```
   Request Method: POST
   URL: http://localhost:4000/api/strategy/execute
   payload:`{ "input": "[1,2,3]", "strategy":"custom" }`

   ```
