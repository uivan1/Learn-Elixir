defmodule Tasks do
  alias Tasks.{Repo, Core.Task}
  @moduledoc """
  Tasks keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Tasks.Core
  #Todas las funciones de integración
   @doc """
    Return a list with all the **tasks** and their pagination data.

    ## Example
        iex> Tasks.list_tasks("empty", 100, 0)
        %{
          items: _items,
          page: _page,
          records: _records,
          total_pages: _total_pages,
          total_records: _total_records
        }

        iex> Tasks.list_tasks("emptys", 100, 0)
        {:error, :cast_error}
    """
  def list_tasks(status, limit, offset) do
    try do
      Core.task_page(status, limit, offset)
    rescue
      Ecto.Query.CastError ->
        {:error, :cast_error}
    end
  end

  @doc """
    Creates a task and returns a tuple with it

    ## Example
        iex> Tasks.insert_task(%{
          name: "example1",
          description: "description1"
        })

        {
          :ok,
          %Tasks.Core.Task{
            __meta__: #Ecto.Schema.Metadata<:loaded, "tasks">,
            description: "description1",
            inserted_at: ~N[2020-11-05 22:28:19],
            name: "example1",
            status: "empty",
            updated_at: ~N[2020-11-05 22:28:19],
            uuid: "e92f2ee6-80f9-492e-b822-6edc8489baaa"
          }
        }

        iex> Tasks.insert_task(
          %{
            description: "description1"
          }
        )
        {
          :error,
          #Ecto.Changeset<
            action: :insert,
            changes: %{description: "description1"},
            errors: [
              name: {"can't be blank", [validation: :required]}
            ],
            data: #Tasks.Core.Task<>,
            valid?: false
          >
        }
    """
  def insert_task(params) do
    %Task{}
    |> Task.changeset(params)
    |> Repo.insert()
  end

  @doc """
    Updates a task and and returns a tuple with it

    ## Example
        iex> Tasks.update_task("bfa43144-5e3b-4133-883f-cca48af56fbd", "to_do")

        {
          :ok,
          %Tasks.Core.Task{
            __meta__: #Ecto.Schema.Metadata<:loaded, "tasks">,
            description: "description1",
            inserted_at: ~N[2020-11-05 22:28:19],
            name: "example1",
            status: "to_do",
            updated_at: ~N[2020-11-05 22:28:19],
            uuid: "e92f2ee6-80f9-492e-b822-6edc8489baaa"
          }
        }

        iex> Tasks.update_task("bfa43144-5e3b-4133-883f-cca48af56fbd", "to_dos")
        {
          :error,
          #Ecto.Changeset<
            action: :update,
            changes: %{},
            errors: [
              status: {"is invalid",
              [type: Enum.TaskStatus, validation: :cast]}
            ],
            data: #Tasks.Core.Task<>,
            valid?: false
          >
        }
    """
  def update_task(task_id, status) do
    case Repo.get(Task, task_id) do
      nil -> {:error, :not_found}
      task ->
        task
        |> Task.status_changeset(%{status: status})
        |> Repo.update()
    end
  end

end
