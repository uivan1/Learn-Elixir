defmodule Tasks.Core.Task do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :uuid}
  @derive {Jason.Encoder, except: [:__struc__, :__meta__]}
  # @derive Jason.Encoder

  schema "tasks" do
    field :name, :string, null: false
    field :description, :string, null: false
    field :status, Enum.TaskStatus, default: "empty"
    timestamps()
  end

  def changeset(struc, params \\ %{}) do
    struc
    |> cast(params, [:name, :description, :status])
    |> validate_required([:name, :description])
    |> validate_length(:name, max: 50, message: "name must be less than 50")
    |> validate_length(:description, max: 200, message: "description must be less than 200")
    |> check_constraint(:name, name: :less_than_50, message: "name must be less than 50")
    |> check_constraint(:description, name: :less_than_200, message: "description must be less than 200")
    |> unique_constraint(:name, message: "this task name is already registered")
  end

  def status_changeset(task, params \\ %{}) do
    task
      |> cast(params, [:status])
      |> validate_required([:status],message: "is required")
  end


end
