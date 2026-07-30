defmodule SubjectManager.Subjects do
  @moduledoc """
  The Subjects context.

  Provides functions for retrieving and filtering football subjects.
  """

  alias SubjectManager.Subjects.Subject

  @type position :: Subject.position()
  @type sort_field :: :name | :team | :position
  @type filters :: %{
          optional(:q) => String.t() | nil,
          optional(:position) => position() | nil,
          optional(:sort_by) => sort_field() | nil
        }

  @doc """
  Returns all subjects without filters or pagination.

      iex> SubjectManager.Subjects.list_subjects()
      []
  """
  @spec list_subjects() :: [Subject.t()]
  defdelegate list_subjects(), to: SubjectManager.Subjects.ListSubjects

  @doc """
  Returns subjects matching the provided filters.

  The `:q` filter performs a case-insensitive partial match against the subject
  name. The `:position` filter matches a position exactly, and `:sort_by`
  supports ascending sorting by name, team, or position.
  """
  @spec list_subjects(filters()) :: [Subject.t()]
  defdelegate list_subjects(filters), to: SubjectManager.Subjects.ListSubjects

  @doc """
  Returns a paginated list of subjects matching the provided filters.

  `limit` controls the maximum number of records returned. `offset` controls
  how many matching records are skipped before collecting the page.
  """
  @spec list_subjects(filters(), pos_integer() | nil, non_neg_integer()) :: [Subject.t()]
  defdelegate list_subjects(filters, limit, offset), to: SubjectManager.Subjects.ListSubjects
end
