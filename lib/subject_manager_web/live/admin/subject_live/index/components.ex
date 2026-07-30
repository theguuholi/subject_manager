defmodule SubjectManagerWeb.Admin.SubjectLive.Index.Components do
  use SubjectManagerWeb, :html

  def subject_row(assigns) do
    ~H"""
    <article id={"subject-#{@subject.id}"} class="flex items-center justify-between border-b p-4">
      <header class="flex items-center gap-4">
        <img src={@subject.image_path} alt={@subject.name} class="h-12 w-12 object-cover" />
        <section>
          <h2>{@subject.name}</h2>
          <p>{@subject.team} · {@subject.position}</p>
        </section>
      </header>

      <nav class="flex gap-4">
        <.link navigate={~p"/subjects/#{@subject}"}>Show</.link>
        <.link id={"edit-subject-#{@subject.id}"} patch={~p"/admin/subjects/#{@subject}/edit"}>
          Edit
        </.link>
        <.link
          id={"delete-subject-#{@subject.id}"}
          phx-click={JS.push("delete", value: %{id: @subject.id})}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </nav>
    </article>
    """
  end
end
