defmodule SubjectManager.Accounts.UserTest do
  @moduledoc """
  Tests for the user schema.
  """

  use SubjectManager.DataCase, async: true

  alias SubjectManager.Accounts.User
  alias SubjectManager.Repo

  describe "role" do
    test "given a new user when the schema is initialized then assigns the guest role" do
      assert %User{role: :guest} = %User{}
    end

    test "given an admin role when a user is persisted then stores the admin role" do
      user =
        Repo.insert!(%User{
          email: "admin-#{System.unique_integer()}@example.com",
          hashed_password: "hashed-password",
          role: :admin
        })

      assert Repo.get!(User, user.id).role == :admin
    end
  end
end
