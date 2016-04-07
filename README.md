# ETS.Ecto

Ecto adapter for ETS table. Might be someday useful for speeding up tests, but right now it's primarly used for learning more about Ecto and ETS.

## Usage

```elixir
# 1. Define `Repo`
defmodule Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: ETS.Ecto
end

# 2. Configure the application
Application.put_env(:my_app, Repo, [])

# 3. Start the Repo process. In a real project you'd put the Repo module in your project's supervision tree:
{:ok, _pid} = Repo.start_link()

# 4. Import Ecto.Query
import Ecto.Query

# 5. Define schema
defmodule Article do
  use Ecto.Schema

  schema "articles" do
    field :title, :string
  end
end

# 6. Interact with the Repo
Repo.insert!(%Article{title: "Article 1"})

q = from(a in Article, select: a.title)
Repo.all(q)
# => ["Article 1"]
```

## Installation

  1. Add `ets_ecto` to your list of dependencies in `mix.exs`:

        def deps do
          [{:ets_ecto, "~> 0.0.1", github: "wojtekmach/ets_ecto"}]
        end

  2. Ensure `ets_ecto` is started before your application:

        def application do
          [applications: [:ets_ecto]]
        end

