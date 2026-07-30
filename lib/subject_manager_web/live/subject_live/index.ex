defmodule SubjectManagerWeb.SubjectLive.Index do
  use SubjectManagerWeb, :live_view

  import SubjectManagerWeb.CustomComponents

  alias SubjectManager.Subjects

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: "Subjects")
      |> assign(subjects: Subjects.list_subjects())
      |> assign(form: to_form(%{}))

    {:ok, socket}
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
    <.form for={@form} id="filter-form">
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
end
