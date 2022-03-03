defmodule Cldr.Trans.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :ex_cldr_trans,
    adapter: Ecto.Adapters.Postgres
end
