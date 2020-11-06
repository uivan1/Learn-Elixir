defmodule TasksWeb.TaskChannelTest do
  use TasksWeb.ChannelCase
  alias TasksWeb.TasksChannel

  test "join channel" do
    assert {:ok, _payload, _socket} = socket("", %{})
      |> subscribe_and_join(TasksChannel, "tasks:board", %{})
  end

  test "receive a reply" do
    assert {:ok, _payload, socket} = socket("", %{})
      |> subscribe_and_join(TasksChannel, "tasks:board", %{})

    push(socket, "tasks:add", %{ name: "hola", description: "mundo"})
    assert_broadcast("tasks:board:new",%{ task: %{ name: "hola", description: "mundo"}})
  end

  test "Error when insert duplicate task" do
    assert {:ok, _payload, socket} = socket("", %{})
      |> subscribe_and_join(TasksChannel, "tasks:board", %{})

      Tasks.insert_task(%{
        name: "hola",
        description: "mundo"
      })

    ref = push(socket, "tasks:add", %{ name: "hola", description: "mundo"})
    assert_reply ref, :error
  end

  test "receive multiple broadcast" do
    assert {:ok, _payload, ulises_socket} = socket("", %{})
    |> subscribe_and_join(TasksChannel, "tasks:board", %{})

    assert {:ok, _payload, _aldo_socket} = socket("", %{})
    |> subscribe_and_join(TasksChannel, "tasks:board", %{})

    push(ulises_socket, "tasks:add", %{ name: "hola", description: "mundo"})
    assert_broadcast("tasks:board:new", %{ task: %{ name: "hola", description: "mundo"}})
    assert_broadcast("tasks:board:new", %{ task: %{ name: "hola", description: "mundo"}})
  end

  test "receive a reply on patch" do
    assert {:ok, _payload, socket} = socket("", %{})
      |> subscribe_and_join(TasksChannel, "tasks:board", %{})

    {:ok, result} = Tasks.insert_task(%{
      name: "nam1",
      description: "012345678901"
    })

    push(socket, "task:patch:#{result.uuid}", %{ status: "empty"})
    assert_broadcast("tasks:board:all",%{})
  end

  test "Error when task id not found" do
    assert {:ok, _payload, socket} = socket("", %{})
      |> subscribe_and_join(TasksChannel, "tasks:board", %{})

    ref = push(socket, "task:patch:bfa43144-5e3b-4233-883f-cca48af56fbd", %{ status: "empty"})
    assert_reply ref, :error
  end

  test "error when status update is invalid value" do
    assert {:ok, _payload, socket} = socket("", %{})
      |> subscribe_and_join(TasksChannel, "tasks:board", %{})

    {:ok, result} = Tasks.insert_task(%{
      name: "nam1",
      description: "012345678901"
    })

    ref = push(socket, "task:patch:#{result.uuid}", %{ status: "emptys"})
    assert_reply ref, :error
  end

end
