#!/bin/bash

# Docker entrypoint script.

# # Wait until Postgres is ready
# while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
# do
#   echo "$(date) - waiting for database to start"
#   sleep 2
# done

# # Create, migrate, and seed database if it doesn't exist.
# if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
#   echo "Database $PGDATABASE does not exist. Creating..."
#   createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
#   mix ecto.migrate
#   mix run priv/repo/seeds.exs
#   echo "Database $PGDATABASE created."
# fi

echo "\n Launching Phoenix web server..."
# Start the phoenix web server
elixir --name erl@172.17.0.1 --cookie secret -S mix phx.server