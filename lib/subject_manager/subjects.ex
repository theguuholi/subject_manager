defmodule SubjectManager.Subjects do
  @moduledoc """
  The Subjects context.

  Provides functions for retrieving and filtering football subjects.
  """

  import Ecto.Query

  alias SubjectManager.Repo
  alias SubjectManager.Subjects.Subject

  @type position :: Subject.position()
  @type sort_field :: :name | :team | :position
  @type filters :: %{
          optional(:q) => String.t() | nil,
          optional(:position) => position() | nil,
          optional(:sort_by) => sort_field() | nil,
          optional(:limit) => pos_integer() | nil,
          optional(:offset) => non_neg_integer()
        }

  @doc """
  Returns subjects matching the provided filters.

  An empty map returns all subjects without filters or pagination. The default
  argument also allows calling this function without arguments.

      iex> SubjectManager.Subjects.list_subjects()
      []

  The `:q` filter performs a case-insensitive partial match against the subject
  name. The `:position` filter matches a position exactly, and `:sort_by`
  supports ascending sorting by name, team, or position. The `:limit` and
  `:offset` filters control pagination.
  """
  @spec list_subjects(filters()) :: [Subject.t()]
  def list_subjects(filters \\ %{}) do
    query = from(subject in Subject)

    filters
    |> Enum.reduce(query, fn
      {:q, query_text}, query when is_binary(query_text) and query_text != "" ->
        pattern = "%#{String.downcase(query_text)}%"

        where(query, [subject], fragment("lower(?) LIKE ?", subject.name, ^pattern))

      {:position, position}, query
      when position in [:forward, :midfielder, :winger, :defender, :goalkeeper] ->
        where(query, [subject], subject.position == ^position)

      {:sort_by, :name}, query ->
        order_by(query, asc: :name)

      {:sort_by, :team}, query ->
        order_by(query, asc: :team)

      {:sort_by, :position}, query ->
        order_by(query, asc: :position)

      {:limit, limit}, query when is_integer(limit) and limit > 0 ->
        limit(query, ^limit)

      {:offset, offset}, query when is_integer(offset) and offset >= 0 ->
        offset(query, ^offset)

      _filter, query ->
        query
    end)
    |> Repo.all()
  end

  @doc """
  Returns the subject with the given ID, raising if it does not exist.
  """
  @spec get_subject!(integer() | String.t()) :: Subject.t()
  def get_subject!(id), do: Repo.get!(Subject, id)
end
