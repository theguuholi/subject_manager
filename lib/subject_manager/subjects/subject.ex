defmodule SubjectManager.Subjects.Subject do
  @moduledoc """
  Schema representing a football subject managed by the application.

  A subject contains biographical information, team and position data, and an
  optional image path used by the subject index page.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type position :: :forward | :midfielder | :winger | :defender | :goalkeeper
  @type t :: %__MODULE__{}

  schema "subjects" do
    field :name, :string
    field :team, :string
    field :position, Ecto.Enum, values: [:forward, :midfielder, :winger, :defender, :goalkeeper]
    field :bio, :string
    field :image_path, :string, default: "/images/placeholder.jpg"

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset for creating or updating a subject.

  The changeset casts the subject fields, requires all subject attributes,
  requires names to contain at least three characters, and requires bios to
  contain at least ten characters.
      iex> alias SubjectManager.Subjects.Subject
      iex> attrs = %{name: "Lionel Messi", team: "Inter Miami", position: :forward, bio: "Argentine forward", image_path: "/images/lionel-messi.jpg"}
      iex> Subject.changeset(%Subject{}, attrs).valid?
      true
  """
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(subject, attrs) do
    subject
    |> cast(attrs, [:name, :team, :position, :bio, :image_path])
    |> validate_required([:name, :team, :position, :bio, :image_path])
    |> validate_length(:name, min: 3)
    |> validate_length(:bio, min: 10)
  end
end
