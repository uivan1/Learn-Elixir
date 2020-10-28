defmodule Tasks.Core do
  alias Tasks.Core.Task
  alias Tasks.Repo
  import Ecto.Query
# funciones de unidad
  def task_page(status, limit \\ 100, offset \\ 0) do
    query =
      Task
      |> fn(query) ->
        case status do
          nil -> query
          _ -> where(query,[t], t.status == ^status)
        end
      end.()

    items =
      query
      |> limit([], ^limit)
      |> offset([], ^offset)
      |> order_by([t], desc: t.updated_at)
      |> distinct(true)
      |> Repo.all()

    total_records =
      query
      |> select([t], count(t.uuid, :distinct))
      |> Repo.one()

    pagination_object(items, offset, limit, total_records)
  end

  defp pagination_object(items, offset, limit, total_records) when
    is_list(items) and
    is_integer(offset) and
    is_integer(limit) and
    is_integer(total_records)
  do
    records = length(items)
    %{
      items: items,
      records: records,
      total_records: total_records,
      page:
        case records do
          0 -> nil
          _ ->
            (offset / limit)
            |> Float.floor()
            |> trunc()
            |> Kernel.+(1)
        end,

      total_pages:
        (total_records / limit)
        |> Float.ceil()
        |> trunc()
    }
  end
end
