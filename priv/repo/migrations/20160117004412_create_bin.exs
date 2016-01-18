defmodule RequestBin.Repo.Migrations.CreateBin do
  use Ecto.Migration

  def change do
    create table(:bins) do
      add :name, :string

      timestamps
    end

  end
end
