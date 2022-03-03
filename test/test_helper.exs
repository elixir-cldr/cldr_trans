require Cldr.Trans.Repo

Cldr.Trans.Repo.start_link()

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Cldr.Trans.Repo, :manual)
