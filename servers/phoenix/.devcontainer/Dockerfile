# Extend from the official Elixir image.
FROM elixir:latest

ENV APP_HOME /app

RUN mkdir -p $APP_HOME

COPY . /app

WORKDIR $APP_HOME

# Install Hex package manager.
# By using `--force`, we don’t need to type “Y” to confirm the installation.
RUN mix local.hex --force

RUN mix local.rebar --force

# Compile the project.
RUN mix deps.get

EXPOSE 4000

CMD [ "sh", "-c", "tail -f /dev/null" ]