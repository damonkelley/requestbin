ExUnit.start

Mix.Task.run "ecto.create", ~w(-r RequestBin.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r RequestBin.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(RequestBin.Repo)

