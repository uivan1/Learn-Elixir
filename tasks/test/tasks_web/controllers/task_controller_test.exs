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

    test "Returns a list of tasks with a range valid" do
      response =
        build_conn()
        |> get(
          Routes.task_path(build_conn(), :list, %{
            pagination: %{
              limit: "10",
              offset: "5"
            }
          })
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

    test "Error when offset pagination is an invalid range"  do
      conn = build_conn()
      response =
        conn
        |> get(
          Routes.task_path(conn, :list, %{
            pagination: %{
              offset: "-5"
            }
          })
        )
        |> json_response(:bad_request)

      assert %{
        "errors" => %{
          "offset" => "Must be more than 0"
        }
      } = response
    end

    test "Error when limit pagination is an invalid range"  do
      conn = build_conn()
      response =
        conn
        |> get(
          Routes.task_path(conn, :list, %{
            pagination: %{
              limit: "200"
            }
          })
        )
        |> json_response(:bad_request)

      assert %{
        "errors" => %{
          "limit" => "Must be in the range 1 to 100"
        }
      } = response
    end
  end

  # Create
  describe "[POST] /task" do

    test "Creates a task and returns it" do
      conn = build_conn()
      response =
        conn
        |> post(
          Routes.task_path(conn, :create, %{
            name: "example1",
            description: "description1"
          })
        )
        |> json_response(:created)

        assert %{
          "message" => "Successful creation of task",
          "data" => _task
        } = response
    end

    test "Error when try to create a task already registered" do
      conn = build_conn()
      response =
        conn
        |> post(
          Routes.task_path(conn, :create, %{
            name: "example1",
            description: "description1"
          })
        )
        |> post(
          Routes.task_path(conn, :create, %{
            name: "example1",
            description: "description1"
          })
        )
        |> json_response(:unprocessable_entity)

        assert %{
          "errors" => %{
            "name" => ["this task name is already registered"]
          }
        } = response
    end

    test "Error when missing name property" do
      conn = build_conn()
      response =
        conn
        |> post(
          Routes.task_path(conn, :create, %{
            description: "description1"
          })
        )
        |> json_response(:unprocessable_entity)

        assert %{
          "errors" => %{
            "name" => ["can't be blank"]
          }
        } = response
    end

    test "Error when missing description property" do
      conn = build_conn()
      response =
        conn
        |> post(
          Routes.task_path(conn, :create, %{
            name: "description1"
          })
        )
        |> json_response(:unprocessable_entity)

        assert %{
          "errors" => %{
            "description" => ["can't be blank"]
          }
        } = response
    end

    test "Error when missing name and descriptions properties" do
      conn = build_conn()
      response =
        conn
        |> post(
          Routes.task_path(conn, :create, %{})
        )
        |> json_response(:unprocessable_entity)

        assert %{
          "errors" => %{
            "description" => ["can't be blank"],
            "name" => ["can't be blank"]
          }
        } = response
    end

    @tag :wip
    test "Error when name exceeds 50 limit characters" do
      conn = build_conn()
      response =
        conn
        |> post(
          Routes.task_path(conn, :create, %{
            name: "012345678901234567890123456789012345678901234567890",
            description: "description1"
          })
        )
        |> json_response(:unprocessable_entity)

        assert %{
          "errors" => %{
            "name" => ["name must be less than 50"]
          }
        } = response
    end

    test "Error when description exceeds 200 limit characters" do
      conn = build_conn()
      response =
        conn
        |> post(
          Routes.task_path(conn, :create, %{
            name: "nam1",
            description: "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
          })
        )
        |> json_response(:unprocessable_entity)

        assert %{
          "errors" => %{
            "description" => ["description must be less than 200"]
          }
        } = response
    end

  end

  # Update
  describe "[PATCH] /task/{task_uuid}" do

    test "Updates a task and returns it" do
      {:ok, newTask} =
        Tasks.insert_task(%{
          name: "example1",
          description: "description1"
        })
      conn = build_conn()
      response =
        conn
        |> patch(
          Routes.task_path(conn, :update, newTask.uuid,%{
            status: "empty"
          })
        )
        |> json_response(:ok)

        assert %{
          "message" => "Successful set of empty status to task",
          "data" => _items,
        } = response
    end

    test "Error when status is invalid" do
      {:ok, newTask} =
        Tasks.insert_task(%{
          name: "example1",
          description: "description1"
        })
      conn = build_conn()
      response =
        conn
        |> patch(
          Routes.task_path(conn, :update, newTask.uuid,%{
            status: "emptys"
          })
        )
        |> json_response(:unprocessable_entity)

        assert %{
          "errors" => %{
            "status" => ["is invalid"]
          }
        } = response
    end

    test "Error when task id not found" do
      conn = build_conn()
      response =
        conn
        |> patch(
          Routes.task_path(conn, :update, "bfa43144-5e3b-4133-883f-cca48af56fbd",%{
            status: "empty"
          })
        )
        |> json_response(:not_found)

        assert %{
          "errors" => %{
            "id" => "task not found"
          }
        } = response
    end

  end

end
