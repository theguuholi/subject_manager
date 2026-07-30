defmodule SubjectManagerWeb.Admin.SubjectLive.Index do
  use SubjectManagerWeb, :live_view

  alias SubjectManager.Subjects
  alias SubjectManager.Subjects.Subject
  alias SubjectManagerWeb.Admin.SubjectLive.Form

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> apply_action(socket.assigns.live_action, params)
      |> assign(:subjects, Subjects.list_subjects())

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    subject = Subjects.get_subject!(id)
    {:ok, _subject} = Subjects.delete_subject(subject)

    {:noreply, update(socket, :subjects, &Enum.reject(&1, fn item -> item.id == subject.id end))}
  end

  defp apply_action(socket, :index, _params), do: assign(socket, page_title: "Subjects")

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(page_title: "New Subject")
    |> assign(:subject, %Subject{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(page_title: "Edit Subject")
    |> assign(:subject, Subjects.get_subject!(id))
  end

  def subject_row(assigns) do
    ~H"""
    <article id={"subject-#{@subject.id}"} class="flex items-center justify-between border-b p-4">
      <div>
        <h2>{@subject.name}</h2>
        <p>{@subject.team} · {@subject.position}</p>
      </div>

      <div class="flex gap-4">
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
      </div>
    </article>
    """
  end
end
