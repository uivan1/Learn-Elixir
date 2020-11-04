defmodule TasksTest do
  use Tasks.DataCase
  alias Tasks.Core.Task
# === Tasks Integration Tests ===============================================
  describe "[Integration] list_tasks():" do

    test "Returns a list of tasks"  do
      result =
        Tasks.list_tasks("empty", 100, 0)
      assert %{
          items: _items,
          page: _page,
          records: _records,
          total_pages: _total_pages,
          total_records: _total_records
      } = result
    end

    test "Error when params invalid value cast in query"  do
      result =
        Tasks.list_tasks("emptys", 100, 0)

      assert {:error, :cast_error
      } = result
    end

  end
  describe "[Integration] insert_task():" do

    test "Creates a task and returns it" do
      result =
        Tasks.insert_task(%{
          name: "example1",
          description: "description1"
        })

      assert {:ok, %Task{}} = result
    end

    test  "Error when try to create a task already registered" do
      Tasks.insert_task(%{
        name: "example1",
        description: "description1"
      })

      result2 =
        Tasks.insert_task(%{
          name: "example1",
          description: "description1"
        })

      assert {:error, %Ecto.Changeset{}} = result2
    end

    test "Error when missing name property" do
      result = Tasks.insert_task(%{
        description: "description1"
      })

      assert {:error, %Ecto.Changeset{}} = result
    end

    test "Error when missing description property" do
      result = Tasks.insert_task(%{
        name: "name1"
      })

      assert {:error, %Ecto.Changeset{}} = result
    end

    test "Error when missing name and description property" do
      result = Tasks.insert_task(%{})

      assert {:error, %Ecto.Changeset{}} = result
    end

    test "Error when name exceeds 50 limit characters" do
      result = Tasks.insert_task(%{
        name: "012345678901234567890123456789012345678901234567890",
        description: "description1"
      })
      assert {:error, %Ecto.Changeset{}} = result
    end

    test "Error when description exceeds 200 limit characters" do
      result = Tasks.insert_task(%{
        name: "nam1",
        description: "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
      })

      assert {:error, %Ecto.Changeset{}} = result
    end
  end

  describe "[Integration] update_task():" do

    test "Updates a task and returns it" do
      {:ok, newTask} =
        Tasks.insert_task(%{
          name: "example1",
          description: "description1"
        })
      result = Tasks.update_task(newTask.uuid, "empty")
      assert {:ok, %Task{}} = result
    end

    test "Error when status is invalid" do
      {:ok, newTask} =
        Tasks.insert_task(%{
          name: "example1",
          description: "description1"
        })
      result = Tasks.update_task(newTask.uuid, "emptys")
      assert {:error, %Ecto.Changeset{}} = result
    end

    test "Error when task id not found" do
      result = Tasks.update_task("bfa43144-5e3b-4133-883f-cca48af56fbd","empty")
      assert {:error, :not_found} = result
    end
  end
end
