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

  test "receive multiple broadcast" do
    assert {:ok, _payload, ulises_socket} = socket("", %{})
    |> subscribe_and_join(TasksChannel, "tasks:board", %{})

    assert {:ok, _payload, _aldo_socket} = socket("", %{})
    |> subscribe_and_join(TasksChannel, "tasks:board", %{})

    push(ulises_socket, "tasks:add", %{ name: "hola", description: "mundo"})
    assert_broadcast("tasks:board:new", %{ task: %{ name: "hola", description: "mundo"}})
    assert_broadcast("tasks:board:new", %{ task: %{ name: "hola", description: "mundo"}})
  end

  # test "receive a reply on patch" do
  #   assert {:ok, _payload, socket} = socket("", %{})
  #     |> subscribe_and_join(TasksChannel, "tasks:board", %{})

  #   push(socket, "task:patch:1", %{ status: "empty"})
  #   assert_broadcast("tasks:board:all",%{})
  # end

end
