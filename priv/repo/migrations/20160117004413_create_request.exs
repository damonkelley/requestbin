defmodule RequestBin.Repo.Migrations.CreateRequest do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :method, :string, size: 32, null: false
      add :headers, :map
      add :body, :binary
      add :remote_ip, :string, size: 16
      add :bin_id, references(:bins)

      timestamps
    end

  end
end
