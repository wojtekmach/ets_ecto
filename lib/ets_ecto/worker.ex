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
