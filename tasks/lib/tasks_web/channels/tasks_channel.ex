defmodule TasksWeb.TasksChannel do
  use TasksWeb, :channel
  alias Tasks.{Core, Repo}
  alias Tasks.Core.Task
  def join("tasks:board", _params, socket) do
    # IO.puts("+++++")
    data = Core.task_page();
    # IO.inspect(data)
    {:ok,  data, socket}
  end

  def handle_in("tasks:add",params, socket) do
    # IO.puts("+++")
    # IO.puts(name)
    # IO.puts(message)

    # changeset = Task.changeset(%Task{}, %{name: name, description: description})
    case Tasks.insert_task(params) do
      {:ok, task} ->
        broadcast!(socket, "tasks:board:new",
          %{task: task}
        )
        {:reply, :ok, socket}
      {:error, task} ->
        response = TasksWeb.TaskView.render("error.json", task: task)
        {:reply, {:error, response}, socket}
    end
  end

  def handle_in("task:patch:" <> task_id,  %{"status" => status}, socket) do
    # IO.puts("+++")
    # IO.puts(id)
    # IO.inspect(status)
    # old_task = Repo.get!(Task, task_id)
    # changeset = Task.status_changeset(old_task, %{status: status})
    case Tasks.update_task(task_id, status) do
      {:ok, _task} ->
          broadcast!(socket, "tasks:board:all", Core.task_page())
        {:reply, :ok, socket}
      {:error, :not_found} ->
        {:reply, {:error, %{errors: %{id:  "task not found"}}}, socket}
      {:error, task} ->
        response = TasksWeb.TaskView.render("error.json", task: task)
        {:reply, {:error, response}, socket}
    end
    # broadcast socket, "patch", status
    # {:noreply, socket}
  end
end
