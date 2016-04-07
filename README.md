# ETS.Ecto

## Installation

  1. Add `ets_ecto` to your list of dependencies in `mix.exs`:

        def deps do
          [{:ets_ecto, "~> 0.0.1", github: "wojtekmach/ets_ecto"}]
        end

  2. Ensure `ets_ecto` is started before your application:

        def application do
          [applications: [:ets_ecto]]
        end

