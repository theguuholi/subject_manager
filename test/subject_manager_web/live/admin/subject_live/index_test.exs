defmodule SubjectManagerWeb.Admin.SubjectLive.IndexTest do
  @moduledoc """
  Tests for the admin subject management page.
  """

  use SubjectManagerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias SubjectManager.Accounts.User
  alias SubjectManager.Repo
  alias SubjectManager.Subjects.Subject

  describe "index" do
    test "given an admin and subjects when the page is mounted then renders subjects and actions",
         %{
           conn: conn
         } do
      admin = admin_fixture()
      subject = subject_fixture()
      conn = log_in_user(conn, admin)

      assert {:ok, view, _html} = live(conn, ~p"/admin/subjects")

      assert has_element?(view, "#subjects")
      assert has_element?(view, "#subject-#{subject.id}", subject.name)

      assert has_element?(
               view,
               "#edit-subject-#{subject.id}[href='/admin/subjects/#{subject.id}/edit']"
             )

      assert has_element?(view, "#delete-subject-#{subject.id}[data-confirm='Are you sure?']")
      assert has_element?(view, "a[href='/admin/subjects/new']", "New Subject")
    end

    test "given an existing subject when delete is confirmed then removes the subject", %{
      conn: conn
    } do
      subject = subject_fixture()
      conn = log_in_user(conn, admin_fixture())

      {:ok, view, _html} = live(conn, ~p"/admin/subjects")

      assert has_element?(view, "#subject-#{subject.id}")

      view |> element("#delete-subject-#{subject.id}") |> render_click()

      refute has_element?(view, "#subject-#{subject.id}")
    end
  end

  describe "authorization" do
    test "given a guest when the admin page is accessed then redirects to the home page", %{
      conn: conn
    } do
      conn = log_in_user(conn, SubjectManager.AccountsFixtures.user_fixture())

      assert {:error, {:redirect, %{to: "/"}}} = live(conn, ~p"/admin/subjects")
    end
  end

  defp admin_fixture do
    Repo.insert!(%User{
      email: "admin-#{System.unique_integer()}@example.com",
      hashed_password: "hashed-password",
      role: :admin
    })
  end

  defp subject_fixture do
    Repo.insert!(%Subject{
      name: "Lionel Messi",
      team: "Inter Miami",
      position: :forward,
      bio: "Argentine professional footballer",
      image_path: "/images/lionel-messi.jpg"
    })
  end
end
