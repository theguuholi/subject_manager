defmodule SubjectManager.Subjects do
  alias SubjectManager.Repo
  alias SubjectManager.Subjects.Subject

  def list_subjects do
    Repo.all(Subject)
  end
end
