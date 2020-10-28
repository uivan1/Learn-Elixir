defmodule Tasks do
  @moduledoc """
  Tasks keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Tasks.Core
  #Todas las funciones de integración
  def list_tasks(status, limit, offset) do
    Core.task_page(status, limit, offset)
  end
end
