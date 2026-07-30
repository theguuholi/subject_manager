defmodule SubjectManagerWeb.Admin.SubjectLive.UploadConfig do
  @moduledoc false

  alias SubjectManagerWeb.Admin.SubjectLive.SimpleS3Upload

  @upload_directory "priv/static/uploads"
  @public_upload_path "/uploads"
  @s3_uploads? Mix.env() == :prod

  def upload_options do
    if production?() do
      [{:external, &s3_metadata/2} | base_upload_options()]
    else
      base_upload_options()
    end
  end

  def consume_entry(meta, entry) do
    if !production?() do
      File.mkdir_p!(@upload_directory)

      image_path = image_path(entry)
      destination = Path.join("priv/static", image_path)

      File.cp!(meta.path, destination)
    end

    {:ok, image_path(entry)}
  end

  def image_path(entry) do
    if production?() do
      Path.join(s3_url(), filename(entry))
    else
      Path.join(@public_upload_path, filename(entry))
    end
  end

  defp base_upload_options do
    [accept: ~w(.png .jpeg .jpg), max_entries: 1, max_file_size: 5_000_000]
  end

  defp filename(entry) do
    extension =
      entry.client_type
      |> MIME.extensions()
      |> List.first()

    "#{entry.uuid}.#{extension}"
  end

  defp production? do
    @s3_uploads?
  end

  defp s3_url do
    bucket = System.fetch_env!("AWS_BUCKET")
    region = System.fetch_env!("AWS_REGION")

    "https://#{bucket}.s3-#{region}.amazonaws.com"
  end

  defp s3_metadata(entry, socket) do
    uploads = socket.assigns.uploads
    bucket = System.fetch_env!("AWS_BUCKET")

    config = %{
      region: System.fetch_env!("AWS_REGION"),
      access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
      secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY")
    }

    {:ok, fields} =
      SimpleS3Upload.sign_form_upload(config, bucket,
        key: filename(entry),
        content_type: entry.client_type,
        max_file_size: uploads[entry.upload_config].max_file_size,
        expires_in: :timer.hours(1)
      )

    metadata = %{
      uploader: "S3",
      key: filename(entry),
      url: s3_url(),
      fields: fields
    }

    {:ok, metadata, socket}
  end
end
