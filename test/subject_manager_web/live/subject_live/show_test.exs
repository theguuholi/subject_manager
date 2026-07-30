defmodule SubjectManagerWeb.SubjectLive.ShowTest do
  @moduledoc """
  Tests for the individual subject landing page.
  """

  use SubjectManagerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias SubjectManager.Repo
  alias SubjectManager.Subjects.Subject

  describe "handle_params/3" do
    test "given an existing subject id when the page is mounted then renders the subject details",
         %{
           conn: conn
         } do
      subject =
        Repo.insert!(%Subject{
          name: "Lionel Messi",
          team: "Inter Miami",
          position: :forward,
          bio: "Argentine professional footballer",
          image_path: "/images/lionel-messi.jpg"
        })

      assert {:ok, view, _live_view} = live(conn, ~p"/subjects/#{subject.id}")

      assert has_element?(view, "#subject-show")
      assert has_element?(view, "#subject-image[src='#{subject.image_path}']")
      assert has_element?(view, "#subject-name", subject.name)
      assert has_element?(view, "#subject-team", subject.team)
      assert has_element?(view, "#subject-position", "forward")
      assert has_element?(view, "#subject-bio", subject.bio)
    end
  end
end
