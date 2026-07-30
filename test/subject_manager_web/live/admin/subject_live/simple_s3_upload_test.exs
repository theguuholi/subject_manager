defmodule SubjectManagerWeb.Admin.SubjectLive.SimpleS3UploadTest do
  use ExUnit.Case, async: true

  alias SubjectManagerWeb.Admin.SubjectLive.SimpleS3Upload

  describe "sign_form_upload/3" do
    test "given S3 upload config when signing form upload then returns signed fields" do
      config = %{
        region: "us-east-1",
        access_key_id: "access-key",
        secret_access_key: "secret-key"
      }

      assert {:ok, fields} =
               SimpleS3Upload.sign_form_upload(config, "subject-bucket",
                 key: "subject-image.jpg",
                 content_type: "image/jpeg",
                 max_file_size: 5_000_000,
                 expires_in: :timer.hours(1)
               )

      assert fields["key"] == "subject-image.jpg"
      assert fields["content-type"] == "image/jpeg"
      assert fields["x-amz-credential"] =~ "access-key/"
      assert fields["x-amz-algorithm"] == "AWS4-HMAC-SHA256"
      assert fields["x-amz-signature"]
    end
  end
end
