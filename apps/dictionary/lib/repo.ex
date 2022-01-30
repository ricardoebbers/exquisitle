defmodule Dictionary.Repo do
  use Ecto.Repo,
    otp_app: :dictionary,
    adapter: Ecto.Adapters.Postgres
end
