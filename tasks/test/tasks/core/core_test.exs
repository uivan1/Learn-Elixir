defmodule CoreTest do
  use Tasks.DataCase
  alias Tasks.Core

  describe "test core" do

    test "test task_page" do

      result =
        Core.task_page(
          "empty"
        )

      assert %{
          items: [],
          page: nil,
          records: 0,
          total_pages: 0,
          total_records: 0
      } = result
    end
  end
end
