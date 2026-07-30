defmodule SubjectManager.SubjectsTest do
  use SubjectManager.DataCase

  alias SubjectManager.Subjects
  alias SubjectManager.Subjects.Subject

  describe "list_subjects/0" do
    test "given no subjects when list_subjects is called then returns an empty list" do
      assert Subjects.list_subjects() == []
    end

    test "given persisted subjects when list_subjects is called then returns all subjects" do
      first_subject = Repo.insert!(%Subject{name: "Lionel Messi"})
      second_subject = Repo.insert!(%Subject{name: "Luis Suárez"})

      subjects = Subjects.list_subjects()

      assert subjects |> MapSet.new(& &1.id) ==
               MapSet.new([first_subject.id, second_subject.id])
    end
  end
end
