defmodule Glimesh.Repo.Migrations.AddGctAuditLog do
  use Ecto.Migration

  def change do

    create table(:gct_audit_log) do
      add :user_id, references(:users, on_delete: :nothing)
      add :action, :string, null: false
      add :target, :string, null: false

      timestamps()
    end
  end
end
