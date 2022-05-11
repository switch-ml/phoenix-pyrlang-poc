defmodule Pyrlangpoc do
  @moduledoc """
  Pyrlangpoc keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use Export.Python

  def call_python_method(count) do
    # path to our python files
    {:ok, py} = Python.start(python_path: Path.expand("lib/python"))

    py |> Python.call("script", "generate_random_numbers", [count])
  end
end
