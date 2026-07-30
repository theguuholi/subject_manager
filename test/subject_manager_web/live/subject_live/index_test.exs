defmodule SubjectManagerWeb.SubjectLive.IndexTest do
  use SubjectManagerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias SubjectManager.Repo
  alias SubjectManager.Subjects.Subject

  describe "mount/3" do
    test "given the root path when the page is mounted then renders the filters and subjects container",
         %{
           conn: conn
         } do
      assert {:ok, view, _live_view} = live(conn, ~p"/")

      assert has_element?(view, "#filter-form")
      assert has_element?(view, "#subjects")
    end

    test "given no subjects when the page is mounted then renders the filters and subjects container",
         %{conn: conn} do
      assert {:ok, view, _live_view} = live(conn, ~p"/subjects")

      assert has_element?(view, "#filter-form")
      assert has_element?(view, "#subjects")
    end

    test "given persisted subjects when the page is mounted then renders each subject card", %{
      conn: conn
    } do
      first_subject = Repo.insert!(%Subject{name: "Lionel Messi"})
      second_subject = Repo.insert!(%Subject{name: "Luis Suárez"})

      assert {:ok, view, _live_view} = live(conn, ~p"/subjects")

      assert has_element?(view, "#subject-#{first_subject.id}")
      assert has_element?(view, "#subject-#{second_subject.id}")
    end
  end
end
