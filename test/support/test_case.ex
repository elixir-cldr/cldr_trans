defmodule Cldr.Trans.TestCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import Cldr.Trans.{TestCase, Factory}
      import Ecto.Query

      alias Cldr.Trans.Repo
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Cldr.Trans.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end
end
