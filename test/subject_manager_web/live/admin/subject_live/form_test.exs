defmodule SubjectManagerWeb.Admin.SubjectLive.FormTest do
  @moduledoc """
  Tests for the admin subject form component.
  """

  use SubjectManagerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias SubjectManager.Accounts.User
  alias SubjectManager.Repo
  alias SubjectManager.Subjects.Subject

  describe "cancel/2" do
    test "given an uploaded image entry when cancel is clicked then removes the preview", %{
      conn: conn
    } do
      conn = log_in_user(conn, admin_fixture())
      {:ok, view, _html} = live(conn, ~p"/admin/subjects/new")

      upload =
        file_input(view, "#subject-form", :image, [
          %{
            last_modified: 1_594_171_879_000,
            name: "cancel-subject.jpg",
            content: "fake image content",
            type: "image/jpeg"
          }
        ])

      ref = hd(upload.entries)["ref"]

      assert render_upload(upload, "cancel-subject.jpg", 50)
      assert has_element?(view, "##{ref}", "cancel-subject.jpg")

      view
      |> element("##{ref} button", "Cancel")
      |> render_click()

      refute has_element?(view, "##{ref}")
    end
  end

  describe "validate/2" do
    test "given invalid subject attributes when form changes then renders validation errors", %{
      conn: conn
    } do
      conn = log_in_user(conn, admin_fixture())
      {:ok, view, _html} = live(conn, ~p"/admin/subjects/new")

      view
      |> form("#subject-form", subject: %{name: "", team: "", position: "forward", bio: ""})
      |> render_change()

      assert has_element?(view, "#subject-form p", "can't be blank")
    end
  end

  describe "save/2" do
    test "given an admin when the new action is opened then renders the subject form", %{
      conn: conn
    } do
      conn = log_in_user(conn, admin_fixture())

      {:ok, view, _html} = live(conn, ~p"/admin/subjects")

      view |> element("a", "New Subject") |> render_click()

      assert_patch(view, ~p"/admin/subjects/new")
      assert has_element?(view, "#subject-modal")
      assert has_element?(view, "#subject-form")
    end

    test "given valid subject attributes when the new form is submitted then creates the subject",
         %{
           conn: conn
         } do
      conn = log_in_user(conn, admin_fixture())
      {:ok, view, _html} = live(conn, ~p"/admin/subjects/new")

      attrs = %{
        name: "New Subject",
        team: "New Team",
        position: "midfielder",
        bio: "A new subject biography"
      }

      {:ok, redirected_view, _html} =
        view
        |> form("#subject-form", subject: attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/subjects")

      created_subject = Repo.get_by!(Subject, name: attrs.name)

      assert has_element?(redirected_view, "#flash-info", "Subject created successfully")
      assert has_element?(redirected_view, "#subject-#{created_subject.id}", attrs.name)

      assert has_element?(
               redirected_view,
               "#subject-#{created_subject.id} img[src='/images/placeholder.jpg']"
             )
    end

    test "given an image upload when the new form is submitted then stores and renders the uploaded image",
         %{
           conn: conn
         } do
      conn = log_in_user(conn, admin_fixture())
      {:ok, view, _html} = live(conn, ~p"/admin/subjects/new")

      upload =
        file_input(view, "#subject-form", :image, [
          %{
            last_modified: 1_594_171_879_000,
            name: "new-subject.jpg",
            content: "fake image content",
            type: "image/jpeg"
          }
        ])

      assert render_upload(upload, "new-subject.jpg", 100)

      attrs = %{
        name: "Uploaded Subject",
        team: "Uploaded Team",
        position: "defender",
        bio: "An uploaded subject biography"
      }

      {:ok, redirected_view, _html} =
        view
        |> form("#subject-form", subject: attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/subjects")

      created_subject = Repo.get_by!(Subject, name: attrs.name)

      on_exit(fn ->
        "priv/static"
        |> Path.join(created_subject.image_path)
        |> File.rm()
      end)

      assert String.starts_with?(created_subject.image_path, "/uploads/")
      assert has_element?(redirected_view, "#subject-#{created_subject.id}")

      assert has_element?(
               redirected_view,
               "#subject-#{created_subject.id} img[src='#{created_subject.image_path}']"
             )
    end

    test "given an existing subject when the edit action is opened then prepopulates the form", %{
      conn: conn
    } do
      subject = subject_fixture()
      conn = log_in_user(conn, admin_fixture())

      {:ok, view, _html} = live(conn, ~p"/admin/subjects")

      view |> element("#edit-subject-#{subject.id}") |> render_click()

      assert_patch(view, ~p"/admin/subjects/#{subject.id}/edit")

      assert has_element?(
               view,
               "#subject-form input[name='subject[name]'][value='#{subject.name}']"
             )
    end

    test "given an existing subject when the edit form is submitted then updates the subject", %{
      conn: conn
    } do
      subject = subject_fixture()
      conn = log_in_user(conn, admin_fixture())

      {:ok, view, _html} = live(conn, ~p"/admin/subjects/#{subject.id}/edit")

      {:ok, redirected_view, _html} =
        view
        |> form("#subject-form", subject: %{name: "Updated Subject"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/subjects")

      assert has_element?(redirected_view, "#flash-info", "Subject updated successfully")
      assert has_element?(redirected_view, "#subject-#{subject.id}", "Updated Subject")
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
