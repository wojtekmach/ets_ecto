defmodule ETS.Ecto.Worker do
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

  def insert_all(schema, entries) do
    objects =
      Enum.map(entries, fn params ->
        {{schema, Keyword.fetch!(params, :id)}, params}
      end)
    :ets.insert(@ets, objects)
  end

  def delete(schema, id) do
    :ets.delete(@ets, {schema, id})
  end

  # TODO: handle invalid id
  # TODO: make atomic
  def update(schema, id, new_params) do
    {{_schema, _id}, params} = :ets.lookup(@ets, {schema, id}) |> hd
    insert(schema, id, Keyword.merge(params, new_params))
  end

  def all do
    :ets.tab2list(@ets)
  end

  def clear do
    :ets.delete_all_objects(@ets)
  end
end
