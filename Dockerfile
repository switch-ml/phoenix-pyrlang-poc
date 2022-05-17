# Extend from the official Elixir image
FROM elixir:latest

ENV DEBIAN_FRONTEND=noninteractive

# installing Postgresql client
RUN apt-get update && \
    apt-get install -y postgresql-client


# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app


# Install hex package manager
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

# Install the Phoenix framework itself
RUN mix archive.install hex phx_new 1.5.3

# apt update
RUN apt-get update

# apt-utils
RUN apt-get install -y apt-utils 

# Suggested https://hexdocs.pm/phoenix/installation.html
RUN apt-get update && apt-get install -y \
    inotify-tools \
    && rm -rf /var/lib/apt/lists/*


# dependencies cleaning
RUN mix deps.clean --all

# Fetching dependencies
RUN mix deps.get --force

RUN mix deps.update --all

# Compile the project
RUN mix do compile

COPY . /app

# Adding persmissions
RUN chmod +x /app/entrypoint.sh

RUN chmod +x entrypoint.sh

EXPOSE 4000

CMD ["/app/entrypoint.sh"]