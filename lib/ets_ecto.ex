defmodule ETS.Ecto do
  ## Boilerplate

  @behaviour Ecto.Adapter

  defmacro __before_compile__(_opts), do: :ok

  def application do
    :ets_ecto
  end

  defmodule Worker do
    use GenServer

    @ets :ets_ecto

    def start_link do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_opts) do
      :ets.new(@ets, [:named_table, :set, :public])
      {:ok, []}
    end

    def insert(schema, id, params) do
      :ets.insert(@ets, {{schema, id}, params})
    end

    def all do
      :ets.tab2list(@ets)
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

  def autogenerate(_) do
    :erlang.unique_integer()
  end

  ## Reads

  def execute(_repo, %{fields: _fields, sources: _sources}, {:nocache, {:all, _query}}, [] = _params, _preprocess, _opts) do
    items =
      for {{schema, _id}, params} <- Worker.all do
        [struct(schema, params)]
      end

    {0, items}
  end

  ## Writes

  def insert(_repo, %{schema: schema}, params, _autogen, _opts) do
    id = Keyword.fetch!(params, :id)
    Worker.insert(schema, id, params)
    {:ok, params}
  end

  def insert_all(_, _, _, _, _, _), do: raise "Not implemented yet"

  def delete(_, _, _, _), do: raise "Not implemented yet"

  def update(_repo, _meta, _params, _filter, _autogen, _opts), do: raise "Not implemented yet"
end
