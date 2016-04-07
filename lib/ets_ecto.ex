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

    def delete(schema, id) do
      :ets.delete(@ets, {schema, id})
    end

    def all do
      :ets.tab2list(@ets)
    end

    def clear do
      :ets.delete_all_objects(@ets)
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

  def execute(_repo, %{fields: fields, sources: _sources}, {:nocache, {:all, _query}}, [] = _params, preprocess, _opts) do
    items =
      for {{_schema, _id}, params} <- Worker.all do
        process_item(params, fields, preprocess)
      end

    {0, items}
  end

  defp process_item(params, [{:&, [], _}] = fields, preprocess) do
    [preprocess.(hd(fields), Keyword.values(params), nil)]
  end
  defp process_item(params, exprs, preprocess) do
    Enum.map(exprs, fn {{:., [], [{:&, [], [0]}, field]}, _, []} ->
      preprocess.(field, Keyword.fetch!(params, field), nil)
    end)
  end

  ## Writes

  def insert(_repo, %{schema: schema}, params, _autogen, _opts) do
    id = Keyword.fetch!(params, :id)
    Worker.insert(schema, id, params)
    {:ok, params}
  end

  def insert_all(_, _, _, _, _, _), do: raise "Not implemented yet"

  def delete(_repo, %{schema: schema}, filter, _opts) do
    id = Keyword.fetch!(filter, :id)
    Worker.delete(schema, id)
    {:ok, []}
  end

  def update(_repo, _meta, _params, _filter, _autogen, _opts), do: raise "Not implemented yet"
end
