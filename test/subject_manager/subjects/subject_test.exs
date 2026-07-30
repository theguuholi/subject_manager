defmodule SubjectManager.Subjects.SubjectTest do
  @moduledoc """
  Tests for the Subject schema and changeset validations.
  """

  use SubjectManager.DataCase, async: true

  alias SubjectManager.Subjects.Subject

  doctest SubjectManager.Subjects.Subject

  describe "changeset/2" do
    test "given valid attributes when changeset is called then returns a valid changeset" do
      attrs = %{
        name: "Lionel Messi",
        team: "Inter Miami",
        position: :forward,
        bio: "Argentine forward",
        image_path: "/images/lionel-messi.jpg"
      }

      changeset = Subject.changeset(%Subject{}, attrs)

      assert changeset.valid?
      assert changeset.changes == attrs
    end

    test "given missing required attributes when changeset is called then returns required field errors" do
      changeset = Subject.changeset(%Subject{}, %{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               team: ["can't be blank"],
               position: ["can't be blank"],
               bio: ["can't be blank"]
             }
    end

    test "given a name shorter than three characters when changeset is called then returns a name length error" do
      attrs = %{
        name: "Jo",
        team: "Inter Miami",
        position: :forward,
        bio: "Argentine forward",
        image_path: "/images/jo.jpg"
      }

      changeset = Subject.changeset(%Subject{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset).name == ["should be at least 3 character(s)"]
    end

    test "given an unsupported position when changeset is called then returns a position error" do
      attrs = %{
        name: "Lionel Messi",
        team: "Inter Miami",
        position: :coach,
        bio: "Argentine forward",
        image_path: "/images/lionel-messi.jpg"
      }

      changeset = Subject.changeset(%Subject{}, attrs)

      refute changeset.valid?
      assert {"is invalid", _options} = changeset.errors[:position]
    end
  end
end
