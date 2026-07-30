defmodule SubjectManagerWeb.SubjectLive.Component do
  use SubjectManagerWeb, :html

  attr(:subject, SubjectManager.Subjects.Subject, required: true)
  attr(:dom_id, :string, required: true)

  def subject(assigns) do
    ~H"""
    <.link navigate={~p"/subjects/#{@subject}"} id={@dom_id}>
      <article class="card">
        <img src={@subject.image_path} alt={@subject.name} />
        <h2>{@subject.name}</h2>
        <footer class="details">
          <p class="team">
            {@subject.team}
          </p>
          <.badge status={@subject.position} />
        </footer>
      </article>
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
end
