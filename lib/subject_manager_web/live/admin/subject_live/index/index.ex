defmodule SubjectManagerWeb.Admin.SubjectLive.Index do
  use SubjectManagerWeb, :live_view

  import __MODULE__.Components

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
end
