defmodule SubjectManager.SubjectsTest do
  @moduledoc """
  Tests for the public Subjects context API.
  """

  use SubjectManager.DataCase

  alias SubjectManager.Subjects
  alias SubjectManager.Subjects.Subject

  doctest SubjectManager.Subjects

  describe "list_subjects/1" do
    test "given no filters when list_subjects is called then returns an empty list" do
      assert Subjects.list_subjects(%{}) == []
    end

    test "given filters with default pagination when list_subjects is called then returns all subjects" do
      first_subject = Repo.insert!(%Subject{name: "Lionel Messi"})
      second_subject = Repo.insert!(%Subject{name: "Luis Suárez"})

      subjects = Subjects.list_subjects(%{})

      assert subjects |> MapSet.new(& &1.id) ==
               MapSet.new([first_subject.id, second_subject.id])
    end

    test "given a name query when list_subjects is called then returns matching subjects case insensitively" do
      matching_subject = Repo.insert!(%Subject{name: "Lionel Messi"})
      Repo.insert!(%Subject{name: "Luis Suárez"})

      subjects = Subjects.list_subjects(%{q: "MESS"})

      assert [matching_subject.id] == Enum.map(subjects, & &1.id)
    end

    test "given a position when list_subjects is called then returns subjects with that position" do
      forward = Repo.insert!(%Subject{name: "Lionel Messi", position: :forward})
      Repo.insert!(%Subject{name: "Emiliano Martínez", position: :goalkeeper})

      subjects = Subjects.list_subjects(%{position: :forward})

      assert [forward.id] == Enum.map(subjects, & &1.id)
    end

    test "given name sorting when list_subjects is called then returns subjects in ascending order" do
      first_subject = Repo.insert!(%Subject{name: "Beta"})
      second_subject = Repo.insert!(%Subject{name: "Alpha"})

      subjects = Subjects.list_subjects(%{sort_by: :name})

      assert [second_subject.id, first_subject.id] == Enum.map(subjects, & &1.id)
    end

    test "given team sorting when list_subjects is called then returns subjects in ascending order" do
      first_subject = Repo.insert!(%Subject{name: "Lionel Messi", team: "Zeta"})
      second_subject = Repo.insert!(%Subject{name: "Luis Suárez", team: "Alpha"})

      subjects = Subjects.list_subjects(%{sort_by: :team})

      assert [second_subject.id, first_subject.id] == Enum.map(subjects, & &1.id)
    end

    test "given position sorting when list_subjects is called then returns subjects in ascending order" do
      first_subject = Repo.insert!(%Subject{name: "Lionel Messi", position: :forward})
      second_subject = Repo.insert!(%Subject{name: "Emiliano Martínez", position: :goalkeeper})

      subjects = Subjects.list_subjects(%{sort_by: :position})

      assert [first_subject.id, second_subject.id] == Enum.map(subjects, & &1.id)
    end

    test "given a limit and offset when list_subjects is called then returns one page of subjects" do
      subjects =
        for index <- 1..3 do
          Repo.insert!(%Subject{name: "Subject #{index}"})
        end

      page = Subjects.list_subjects(%{limit: 1, offset: 1})

      assert [Enum.at(subjects, 1).id] == Enum.map(page, & &1.id)
    end
  end

  describe "get_subject!/1" do
    test "given an existing subject id when get_subject is called then returns the subject" do
      subject = Repo.insert!(%Subject{name: "Lionel Messi"})

      assert Subjects.get_subject!(subject.id) == subject
    end
  end
end
