defmodule SubjectManagerWeb.SubjectLive.Index do
  use SubjectManagerWeb, :live_view

  import SubjectManagerWeb.CustomComponents

  alias SubjectManager.Subjects

  @positions ~w(forward midfielder winger defender goalkeeper)
  @sort_fields ~w(name team position)

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Subjects")}
  end

  def handle_params(params, _uri, socket) do
    filters = filters_from_params(params)

    {:noreply,
     socket
     |> assign(:subjects, Subjects.list_subjects(filters))
     |> assign(:form, to_form(params, as: :filter))}
  end

  def handle_event("filter", params, socket) do
    params = Map.get(params, "filter", params)

    {:noreply, push_patch(socket, to: filter_path(params))}
  end

  attr(:subject, SubjectManager.Subjects.Subject, required: true)
  attr(:dom_id, :string, required: true)

  def subject(assigns) do
    ~H"""
    <.link navigate="#" id={@dom_id}>
      <div class="card">
        <img src={@subject.image_path} />
        <h2>{@subject.name}</h2>
        <div class="details">
          <div class="team">
            {@subject.team} - "~p/subjects/@subject"
          </div>
          <.badge status={@subject.position} />
        </div>
      </div>
    </.link>
    """
  end

  attr(:form, Phoenix.HTML.Form, required: true)

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter" phx-submit="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" />
      <.input
        type="select"
        field={@form[:position]}
        prompt="Position"
        options={[
          Forward: "forward",
          Midfielder: "midfielder",
          Winger: "winger",
          Defender: "defender",
          Goalkeeper: "goalkeeper"
        ]}
      />
      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort By"
        options={[
          Name: "name",
          Team: "team",
          Position: "position"
        ]}
      />

      <.link patch={~p"/subjects"}>
        Reset
      </.link>
    </.form>
    """
  end

  defp filters_from_params(params) do
    %{
      q: Map.get(params, "q"),
      position: valid_param(Map.get(params, "position"), @positions),
      sort_by: valid_param(Map.get(params, "sort_by"), @sort_fields)
    }
  end

  defp valid_param(param, allowed) do
    if is_binary(param) and param in allowed do
      String.to_existing_atom(param)
    end
  end

  defp filter_path(params) do
    query_params =
      params
      |> Map.take(["q", "position", "sort_by"])
      |> Enum.reject(fn {_key, value} -> value in [nil, ""] end)
      |> Map.new()

    case URI.encode_query(query_params) do
      "" -> ~p"/subjects"
      query -> "/subjects?#{query}"
    end
  end
end
