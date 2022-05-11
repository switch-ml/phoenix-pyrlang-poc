defmodule Pyrlangpoc.Helper do
  @doc """
   Start python instance with custom modules dir priv/python
  """
  def start() do
    path =
      [
        :code.priv_dir(:pyrlangpoc),
        "python"
      ]
      |> Path.join()

    {:ok, pid} =
      :python.start([
        {:python_path, to_charlist(path)}
      ])

    pid
  end

  def call(pid, m, f, a \\ []) do
    :python.call(pid, m, f, a)
  end

  def cast(pid, message) do
    :python.cast(pid, message)
  end

  def stop(pid) do
    :python.stop(pid)
  end
end
