defmodule SubjectManagerWeb.Admin.SubjectLive.UploadConfigTest do
  use ExUnit.Case, async: false

  alias SubjectManagerWeb.Admin.SubjectLive.UploadConfig

  describe "upload_options/0" do
    test "given local environment when upload options are built then uses local LiveView uploads" do
      refute Keyword.has_key?(UploadConfig.upload_options(), :external)
    end
  end

  describe "image_path/1" do
    test "given local environment when image path is built then returns the local upload path" do
      entry = %{client_type: "image/jpeg", uuid: "subject-image"}

      assert UploadConfig.image_path(entry) == "/uploads/subject-image.jpg"
    end
  end
end
