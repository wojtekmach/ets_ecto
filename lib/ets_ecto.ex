defmodule ETS.Ecto do
  ## Boilerplate

  @behaviour Ecto.Adapter

  defmacro __before_compile__(_opts), do: :ok

  def application do
    :ets_ecto
  end

  defmodule Worker do
    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end
  end

  def child_spec(_repo, _opts) do
    Supervisor.Spec.worker(Worker, [])
  end

  def stop(_, _, _), do: :ok

  def loaders(primitive, _type), do: [primitive]

  def dumpers(primitive, _type), do: [primitive]

  def embed_id(_), do: ObjectID.generate

  def prepare(operation, query), do: {:nocache, {operation, query}}

  def autogenerate(_), do: raise "Not supported by adapter"

  ## Reads

  def execute(_repo, %{fields: _fields, sources: _sources}, {:nocache, {:all, _query}}, [] = _params, _preprocess, _opts) do
    {0, []}
  end

  ## Writes

  def insert(_repo, _meta, _params, _autogen, _opts), do: raise "Not implemented yet"

  def insert_all(_, _, _, _, _, _), do: raise "Not implemented yet"

  def delete(_, _, _, _), do: raise "Not implemented yet"

  def update(_repo, _meta, _params, _filter, _autogen, _opts), do: raise "Not implemented yet"
end
