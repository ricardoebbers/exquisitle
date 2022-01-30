defmodule Dictionary.Repo.Migrations.SeedWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :word, :string
      add :type, :string
    end
  end
end
