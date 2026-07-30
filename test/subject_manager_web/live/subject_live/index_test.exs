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

  describe "handle_params/3" do
    test "given a name query when the page is mounted then renders matching subjects", %{
      conn: conn
    } do
      matching_subject = Repo.insert!(%Subject{name: "Lionel Messi"})
      non_matching_subject = Repo.insert!(%Subject{name: "Luis Suárez"})

      assert {:ok, view, _live_view} = live(conn, ~p"/subjects?q=MESS")

      assert has_element?(view, "#subject-#{matching_subject.id}")
      refute has_element?(view, "#subject-#{non_matching_subject.id}")
    end

    test "given a position filter when the page is mounted then renders matching subjects", %{
      conn: conn
    } do
      matching_subject = Repo.insert!(%Subject{name: "Lionel Messi", position: :forward})

      non_matching_subject =
        Repo.insert!(%Subject{name: "Emiliano Martínez", position: :goalkeeper})

      assert {:ok, view, _live_view} = live(conn, ~p"/subjects?position=forward")

      assert has_element?(view, "#subject-#{matching_subject.id}")
      refute has_element?(view, "#subject-#{non_matching_subject.id}")
    end

    test "given a sort query when the page is mounted then renders subjects in the requested order",
         %{conn: conn} do
      first_subject = Repo.insert!(%Subject{name: "Beta"})
      second_subject = Repo.insert!(%Subject{name: "Alpha"})

      assert {:ok, view, _live_view} = live(conn, ~p"/subjects?sort_by=name")

      assert has_element?(view, "#subjects > a:nth-of-type(1)#subject-#{second_subject.id}")
      assert has_element?(view, "#subjects > a:nth-of-type(2)#subject-#{first_subject.id}")
    end
  end

  describe "handle_event/3" do
    test "given empty filters when the form changes then patches the unfiltered page", %{
      conn: conn
    } do
      assert {:ok, view, _live_view} = live(conn, ~p"/subjects")

      view
      |> element("#filter-form")
      |> render_change(%{"filter" => %{"q" => "", "position" => "", "sort_by" => ""}})

      assert_patch(view, ~p"/subjects")
    end

    test "given a name filter when the form changes then patches the page with matching subjects",
         %{
           conn: conn
         } do
      matching_subject = Repo.insert!(%Subject{name: "Lionel Messi"})
      non_matching_subject = Repo.insert!(%Subject{name: "Luis Suárez"})

      assert {:ok, view, _live_view} = live(conn, ~p"/subjects")

      view
      |> element("#filter-form")
      |> render_change(%{"filter" => %{"q" => "MESS"}})

      assert_patch(view, ~p"/subjects?q=MESS")
      assert has_element?(view, "#subject-#{matching_subject.id}")
      refute has_element?(view, "#subject-#{non_matching_subject.id}")
    end

    test "given active filters when reset is clicked then patches the unfiltered page", %{
      conn: conn
    } do
      assert {:ok, view, _live_view} = live(conn, ~p"/subjects?q=MESS&position=forward")

      view
      |> element("#filter-form a", "Reset")
      |> render_click()

      assert_patch(view, ~p"/subjects")
    end
  end
end
