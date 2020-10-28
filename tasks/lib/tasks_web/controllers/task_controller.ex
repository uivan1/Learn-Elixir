defmodule TasksWeb.TaskController do
  use TasksWeb, :controller
  alias Tasks.{Repo, Core.Task}
  @doc """
    Returns a list of tasks generated from the parameters provided
  """

  def list(conn, _params) do

    status = conn.query_params["status"]
    lim = conn.query_params["pagination"]["limit"]
    offs = conn.query_params["pagination"]["offset"]

    limit = case lim do
      nil -> 100
      _ ->
      case Integer.parse(lim, 10) do
        {integer, ""} -> integer
        _ -> 100
      end
    end

    offset = case offs do
      nil -> 0
      _ ->
      case Integer.parse(offs, 10) do
        {integer, ""} -> integer
        _ -> 0
      end
    end

    cond do

      limit not in 1..100 ->
        conn
        |> put_status(400)
        |> json(%{errors: %{limit:  "Must be in the range 1 to 100"}})

      not (offset >= 0) ->
        conn
        |> put_status(400)
        |> json(%{errors: %{offset:  "Must be more than 0"}})

      not is_nil(status) and Enum.TaskStatus.valid_value?(status) == false ->
        conn
        |> put_status(400)
        |> json(%{errors: %{status:  "Invalid status value"}})
      #
      not is_nil(lim) and !Regex.match?(~r{\A\d*\z}, lim) ->
        conn
        |> put_status(400)
        |> json(%{errors: %{limit:  "limit needs to be a number"}})

      not is_nil(offs) and !Regex.match?(~r{\A\d*\z}, offs) ->
        conn
        |> put_status(400)
        |> json(%{errors: %{offset:  "offset needs to be a number"}})

      true ->
        data = Tasks.list_tasks(status, limit, offset)
        render(conn, "index.json", data: data)
    end
  end

  # if recive an object tipe task Pattern matching %{"task" => task}
  def create(conn,params) do
    IO.inspect(params, label: "project_params")
    changeset = Task.changeset(%Task{}, params)
    case Repo.insert(changeset) do
      {:ok, task} ->
        conn
        |> put_status(:created)
        |> render("create.json", task: task)
      {:error, task} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", task: task)
    end
  end

  def update(conn,%{"id" => task_id, "status" => status}) do
      try do
        old_task = Repo.get!(Task, task_id)
        changeset = Task.status_changeset(old_task, %{status: status})
        case Repo.update(changeset) do
        {:ok, task} ->
          conn
          |> render("status.json", task: task)
          {:error, task} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", task: task)
        end
      rescue
        Ecto.NoResultsError ->
        conn
        |> put_status(404)
        |> json(%{errors: %{id:  "task not found"}})
      end
  end

end
