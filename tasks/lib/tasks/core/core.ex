defmodule Tasks.Core do
  alias Tasks.Core.Task
  alias Tasks.Repo
  import Ecto.Query
# funciones de unidad
@doc """
  Return a list with all the **task** according to the indicated parameters.

  ## Example
      iex> Tasks.Core.task_page()
      %{
        items: [
          %Tasks.Core.Task{
            __meta__: #Ecto.Schema.Metadata<:loaded, "tasks">,
            description: "sdsad",
            inserted_at: ~N[2020-11-02 16:50:31],
            name: "ejemplo 2",
            status: :to_do,
            updated_at: ~N[2020-11-05 19:36:52],
            uuid: "0c6edc79-1ee3-47bc-8df1-2b2aadc5201c"
          },
          ...
        ]
        page: _page,
        records: _records,
        total_pages: _total_pages,
        total_records: _total_records
      }
  """
  def task_page(status \\ nil, limit \\ 100, offset \\ 0) do
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
