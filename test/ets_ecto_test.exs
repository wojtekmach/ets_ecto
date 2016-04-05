defmodule Article do
  use Ecto.Schema

  schema "articles" do
    field :title, :string
  end
end

defmodule ETS.EctoTest do
  use ExUnit.Case
  import Ecto.Query

  test "the truth" do
    q = from(a in Article)
    assert [] = TestRepo.all(q)

    TestRepo.insert!(%Article{title: "Title 1"})
    assert [%Article{title: "Title 1"}] = TestRepo.all(q)
  end
end
