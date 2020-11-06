defmodule Tasks.Core.Task do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc """
  This module have the schemas that represent the tasks.
  """

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

  @doc """
    Insert a **task** into the database.

  ## Example
      iex> attrs = %{
          ...>   name: "example1",
          ...>   description: "description1"
          ...> }

      iex> Tasks.Core.Task.changeset(%Tasks.Core.Task{}, attrs)
        #Ecto.Changeset<
          action: nil,
          changes: %{description: "description1", name: "example1"},
          errors: [],
          data: #Tasks.Core.Task<>,
          valid?: true
        >

      iex> attrs = %{
          ...>   description: "description1"
          ...> }

      #Ecto.Changeset<
        action: nil,
        changes: %{description: "description1"},
        errors: [name: {"can't be blank", [validation: :required]}],
        data: #Tasks.Core.Task<>,
        valid?: false
      >
  """
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
 @doc """
    Modify in the database the given **task** with the status in the `attrs`.

    ## Example
        iex> attrs = %{status: "to_do"}
        iex> Tasks.Core.Task.status_changeset(%Tasks.Core.Task{}, attrs)

        #Ecto.Changeset<
          action: nil,
          changes: %{status: :to_do},
          errors: [],
          data: #Tasks.Core.Task<>,
          valid?: true
        >

        iex> attrs = %{status: "to_dos"}
        #Ecto.Changeset<
          action: nil,
          changes: %{},
          errors: [status: {"is invalid", [type: Enum.TaskStatus, validation: :cast]}],
          data: #Tasks.Core.Task<>,
          valid?: false
        >
  """
  def status_changeset(task, params \\ %{}) do
    task
      |> cast(params, [:status])
      |> validate_required([:status],message: "is required")
  end


end
