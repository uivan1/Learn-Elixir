defmodule TasksWeb.TaskControllerTest do
  use TasksWeb.ConnCase

  describe "[GET] /task" do
    test "Returns a list of tasks" do
      response =
        build_conn()
        |> get(
          Routes.task_path(build_conn(), :list, %{})
        )
        |> json_response(:ok)

      assert %{
        "message" => "Successful list of tasks",
        "data" => _items,
        "records" => _records,
        "total_records" => _total_records,
        "page" => _page,
        "total_pages" => _total_pages
      } = response
    end

    test "Error when status is an invalid value"  do
      conn = build_conn()
      response =
        conn
        |> get(
          Routes.task_path(conn, :list, %{
            status: "emptys",
          })
        )
        |> json_response(:bad_request)

      assert %{
        "errors" => %{
          "status" => "Invalid status value"
        }
      } = response
    end

    test "Error when limit pagination is an invalid value"  do
      conn = build_conn()
      response =
        conn
        |> get(
          Routes.task_path(conn, :list, %{
            pagination: %{
              limit: "asd"
            }
          })
        )
        |> json_response(:bad_request)

      assert %{
        "errors" => %{
          "limit" => "limit needs to be a number"
        }
      } = response
    end
    test "Error when offset pagination is an invalid value"  do
      conn = build_conn()
      response =
        conn
        |> get(
          Routes.task_path(conn, :list, %{
            pagination: %{
              offset: "asd"
            }
          })
        )
        |> json_response(:bad_request)

      assert %{
        "errors" => %{
          "offset" => "offset needs to be a number"
        }
      } = response
    end
  end

end
