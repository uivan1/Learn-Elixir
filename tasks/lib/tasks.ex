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
  def list_tasks(status, limit, offset) do
    try do
      Core.task_page(status, limit, offset)
    rescue
      Ecto.Query.CastError ->
        {:error, :cast_error}
    end
  end

  def insert_task(params) do
    %Task{}
    |> Task.changeset(params)
    |> Repo.insert()
  end

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
