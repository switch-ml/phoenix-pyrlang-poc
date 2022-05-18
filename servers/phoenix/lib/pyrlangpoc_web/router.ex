defmodule PyrlangpocWeb.Router do
  use PyrlangpocWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PyrlangpocWeb do
    pipe_through :api
  end
end
