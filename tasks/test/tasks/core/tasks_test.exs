defmodule TasksWeb.TaskTest do
  # use TasksWeb.ConnCase, async: true
  use Tasks.DataCase, async: true
  alias Tasks.Core.Task


  # --- Unit Tests -------------------------------------------------------------

  describe "Tasks.Core.Task changesets" do
    @invalid_attrs %{}
    @valid_attrs %{
      description: "Example description 21 Example description ",
      id: "8f47f79b-b1f7-4dc5-b632-35815a1ceb9e",
      inserted_at: "2020-10-26T22:25:12",
      name: "example 21",
      status: "empty",
      updated_at: "2020-10-26T22:25:12"
    }

    test "changeset with invalid attributes" do
      changeset = Task.changeset(%Task{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "changeset with valid attributes" do
      changeset = Task.changeset(%Task{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changest with name and description validation" do
      changeset = Task.changeset(%Task{}, %{})
      assert %{name: ["can't be blank"], description: ["can't be blank"]} = errors_on(changeset)
    end

    test "changest with name max characters 50" do
      changeset = Task.changeset(%Task{}, %{@valid_attrs | name: "012345678901234567890123456789012345678901234567890"})
      assert %{name: ["name must be less than 50"]} = errors_on(changeset)
    end

    test "changest with desciption max characters 200" do
      changeset = Task.changeset(%Task{}, %{@valid_attrs | description: "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"})
      assert %{description: ["description must be less than 200"]} = errors_on(changeset)
    end

  end
end
