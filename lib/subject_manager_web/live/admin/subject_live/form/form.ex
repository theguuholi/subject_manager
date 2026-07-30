defmodule SubjectManagerWeb.Admin.SubjectLive.Form do
  use SubjectManagerWeb, :live_component

  alias SubjectManager.Subjects
  alias SubjectManagerWeb.Admin.SubjectLive.UploadConfig

  @impl true
  def update(%{subject: subject} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, Subjects.change_subject(subject))}
    |> allow_subject_upload()
  end

  @impl true
  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
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
  def handle_event("validate", _params, socket), do: {:noreply, socket}

  @impl true
  def handle_event("save", %{"subject" => params}, socket) do
    save(socket, socket.assigns.action, put_image_path(socket, params))
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

  defp allow_subject_upload({:ok, socket}) do
    {:ok, allow_upload(socket, :image, UploadConfig.upload_options())}
  end

  defp put_image_path(socket, params) do
    case uploaded_entries(socket, :image) do
      {[entry | _entries], []} ->
        consume_uploaded_entries(socket, :image, &UploadConfig.consume_entry/2)
        Map.put(params, "image_path", UploadConfig.image_path(entry))

      {[], []} ->
        Map.put_new(params, "image_path", socket.assigns.subject.image_path)
    end
  end
end
