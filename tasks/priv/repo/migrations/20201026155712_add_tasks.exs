defmodule Tasks.Repo.Migrations.AddTasks do
  use Ecto.Migration

  def change do
    Enum.TaskStatus.create_type
    create table(:tasks, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :text, null: false
      add :description, :text, null: false
      add :status,
        Enum.TaskStatus.type(),
        null: false,
        default: "empty"
      timestamps()
    end
    create unique_index(:tasks, [:name])
    create constraint(:tasks, :less_than_50, check: "LENGTH(name) < 51")
    create constraint(:tasks, :less_than_200, check: "LENGTH(description) < 201")
  end


end
