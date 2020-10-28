defmodule TasksWeb.TaskView do
  use TasksWeb, :view
  def render("index.json", %{data: data}) do
    %{
      data: render_many(data.items, TasksWeb.TaskView, "task.json"),
      message: "Successful list of tasks",
      records: data.records,
      total_records: data.total_records,
      page: data.page,
      total_pages: data.total_pages
    }
  end
  def render("create.json", %{task: task}) do
    %{
      data: render_one(task, TasksWeb.TaskView, "task.json"),
      message: "Successful creation of task",
    }
  end
  def render("status.json", %{task: task}) do
    %{
      data: render_one(task, TasksWeb.TaskView, "task.json"),
      message: "Successful set of #{task.status} status to task",
    }
  end
  def render("error.json", %{task: task}) do
    %{errors: translate_errors(task)}
  end
  def render("task.json", %{task: task}) do
    %{id: task.uuid,
      name: task.name,
      description: task.description,
      status: task.status,
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end
  defp translate_errors(task) do
    Ecto.Changeset.traverse_errors(task, &translate_error/1)
  end
end
