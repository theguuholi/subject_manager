defmodule SubjectManagerWeb.SubjectLive.Show do
  use SubjectManagerWeb, :live_view

  alias SubjectManager.Subjects

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    subject = Subjects.get_subject!(id)

    {:noreply,
     socket
     |> assign(:subject, subject)
     |> assign(page_title: subject.name)}
  end
end
