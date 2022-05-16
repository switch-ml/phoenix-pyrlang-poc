defmodule Pyrlangpoc.Repo do
  use Ecto.Repo,
    otp_app: :pyrlangpoc,
    adapter: Ecto.Adapters.Postgres
end
