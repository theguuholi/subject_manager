defmodule SubjectManagerWeb.Admin.SubjectLive.Form do
  use SubjectManagerWeb, :live_component

  alias SubjectManager.Subjects

  @impl true
  def update(%{subject: subject} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, Subjects.change_subject(subject))}
  end

  @impl true
  def handle_event("validate", %{"subject" => params}, socket) do
    changeset =
      socket.assigns.subject
      |> Subjects.change_subject(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"subject" => params}, socket) do
    save(socket, socket.assigns.action, params)
  end

  defp save(socket, :new, params) do
    params
    |> Subjects.create_subject()
    |> respond(socket, "Subject created successfully")
  end

  defp save(socket, :edit, params) do
    socket.assigns.subject
    |> Subjects.update_subject(params)
    |> respond(socket, "Subject updated successfully")
  end

  defp respond({:ok, _subject}, socket, message) do
    {:noreply,
     socket
     |> put_flash(:info, message)
     |> push_navigate(to: socket.assigns.navigate)}
  end

  defp respond({:error, changeset}, socket, _message) do
    {:noreply, assign(socket, :changeset, changeset)}
  end
end
