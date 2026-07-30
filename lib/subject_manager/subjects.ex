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

  @doc """
  Returns a changeset for creating or updating a subject.

  ## Examples
      iex> alias SubjectManager.Subjects
      iex> alias SubjectManager.Subjects.Subject
      iex> attrs = %{name: "Lionel Messi", team: "Inter Miami", position: :forward, bio: "Argentine forward", image_path: "/images/messi.jpg"}
      iex> Subjects.change_subject(%Subject{}, attrs).valid?
      true
  """
  @spec change_subject(Subject.t(), map()) :: Ecto.Changeset.t()
  def change_subject(subject, attrs \\ %{}), do: Subject.changeset(subject, attrs)

  @doc """
  Creates a subject from the given attributes.

  ## Examples

      iex> attrs = %{name: "Lionel Messi", team: "Inter Miami", position: :forward, bio: "Argentine professional footballer", image_path: "/images/messi.jpg"}
      iex> {:ok, subject} = SubjectManager.Subjects.create_subject(attrs)
      iex> {:ok, deleted_subject} = SubjectManager.Subjects.delete_subject(subject)
      iex> deleted_subject.id == subject.id
      true
  """
  @spec create_subject(map()) :: {:ok, Subject.t()} | {:error, Ecto.Changeset.t()}
  def create_subject(attrs) do
    %Subject{}
    |> Subject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subject with the given attributes.

  ## Examples

      iex> attrs = %{name: "Lionel Messi", team: "Inter Miami", position: :forward, bio: "Argentine professional footballer", image_path: "/images/messi.jpg"}
      iex> {:ok, subject} = SubjectManager.Subjects.create_subject(attrs)
      iex> {:ok, updated_subject} = SubjectManager.Subjects.update_subject(subject, %{name: "Updated Subject"})
      iex> updated_subject.name
      "Updated Subject"
      iex> {:ok, deleted_subject} = SubjectManager.Subjects.delete_subject(updated_subject)
      iex> deleted_subject.name
      "Updated Subject"
  """
  @spec update_subject(Subject.t(), map()) :: {:ok, Subject.t()} | {:error, Ecto.Changeset.t()}
  def update_subject(subject, attrs) do
    subject
    |> Subject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subject.

  ## Examples

      iex> attrs = %{name: "Lionel Messi", team: "Inter Miami", position: :forward, bio: "Argentine professional footballer", image_path: "/images/messi.jpg"}
      iex> {:ok, subject} = SubjectManager.Subjects.create_subject(attrs)
      iex> {:ok, deleted_subject} = SubjectManager.Subjects.delete_subject(subject)
      iex> deleted_subject.id == subject.id
      true
  """
  @spec delete_subject(Subject.t()) :: {:ok, Subject.t()} | {:error, Ecto.Changeset.t()}
  def delete_subject(subject), do: Repo.delete(subject)
end
