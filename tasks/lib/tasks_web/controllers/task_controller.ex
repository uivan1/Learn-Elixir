defmodule TasksWeb.TaskController do
  use TasksWeb, :controller
    @moduledoc """
    Controller of Task Schema with methods web
  """
  @doc """
    Returns a list of tasks generated from the parameters provided

  ## Example
        iex> TasksWeb.TaskController.list(Phoenix.ConnTest.build_conn(),%{})

        %{
          "message" => "Successful list of tasks",
          "data" => _items,
          "records" => _records,
          "total_records" => _total_records,
          "page" => _page,
          "total_pages" => _total_pages
        }

        iex> TasksWeb.TaskController.list(Phoenix.ConnTest.build_conn(), %{status: "emptys"})
        %{
          "errors" => %{
            "status" => "Invalid status value"
          }
        }
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
  @doc """
    Returns a task from a json

  ## Example
        iex>  TasksWeb.TaskController.list(Phoenix.ConnTest.build_conn(),%{
          ...> name: "example1",
          ...> description: "description1"
          ...> })

        %{
          "message" => "Successful creation of task",
          "data" => _task
        }

        iex>  TasksWeb.TaskController.list(Phoenix.ConnTest.build_conn(),%{
          ...> description: "description1"
          ...> })

        %{
          "errors" => %{
            "name" => ["can't be blank"]
          }
        }
  """
  def create(conn,params) do
    case Tasks.insert_task(params) do
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
  @doc """
    Update status of a task and return it in json format

  ## Example
        iex>  TasksWeb.TaskController.update(Phoenix.ConnTest.build_conn(),%{
          ...> id: "bfa43144-5e3b-4133-883f-cca48af56fbd",
          ...> status: "to_do"
          ...> })

        assert %{
          "message" => "Successful set of empty to_do to task",
          "data" => _items,
        }

        iex>  TasksWeb.TaskController.list(Phoenix.ConnTest.build_conn(),%{
          ...> id: "bfa43144-5e3b-4133-883f-cca48af56f3d",
          ...> status: "to_do"
          ...> })

        %{
          "errors" => %{
            "status" => ["is invalid"]
          }
        }
  """
  def update(conn,%{"id" => task_id, "status" => status}) do
        case Tasks.update_task(task_id, status) do
        {:ok, task} ->
          conn
          |> render("status.json", task: task)
        {:error, :not_found} ->
          conn
          |> put_status(404)
          |> json(%{errors: %{id:  "task not found"}})
        {:error, task} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", task: task)
      end
  end

end
