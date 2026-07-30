defmodule SubjectManager.Subjects do
  import Ecto.Query

  alias SubjectManager.Repo
  alias SubjectManager.Subjects.Subject

  def list_subjects do
    list_subjects(%{})
  end

  def list_subjects(filters), do: list_subjects(filters, nil, 0)

  def list_subjects(filters, limit, offset) do
    Subject
    |> filter_by_name(Map.get(filters, :q))
    |> filter_by_position(Map.get(filters, :position))
    |> sort_by(Map.get(filters, :sort_by))
    |> paginate(limit, offset)
    |> Repo.all()
  end

  defp filter_by_name(query, query_text) when is_binary(query_text) and query_text != "" do
    pattern = "%#{String.downcase(query_text)}%"

    where(query, [subject], fragment("lower(?) LIKE ?", subject.name, ^pattern))
  end

  defp filter_by_name(query, _query_text), do: query

  defp filter_by_position(query, position)
       when position in [:forward, :midfielder, :winger, :defender, :goalkeeper] do
    where(query, [subject], subject.position == ^position)
  end

  defp filter_by_position(query, _position), do: query

  defp sort_by(query, :name), do: order_by(query, asc: :name)
  defp sort_by(query, :team), do: order_by(query, asc: :team)
  defp sort_by(query, :position), do: order_by(query, asc: :position)
  defp sort_by(query, _sort_by), do: query

  defp paginate(query, limit, offset)
       when is_integer(limit) and limit > 0 and is_integer(offset) and offset >= 0 do
    query
    |> limit(^limit)
    |> offset(^offset)
  end

  defp paginate(query, _limit, _offset), do: query
end
