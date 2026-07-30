defmodule SubjectManagerWeb.StaticTest do
  use SubjectManagerWeb.ConnCase

  describe "static_paths/0" do
    test "given an uploaded file when it is requested then serves the file", %{conn: conn} do
      upload_directory = Path.join(["priv", "static", "uploads"])
      uploaded_file = Path.join(upload_directory, "static-test.txt")

      File.mkdir_p!(upload_directory)
      File.write!(uploaded_file, "uploaded file")

      on_exit(fn -> File.rm(uploaded_file) end)

      conn = get(conn, "/uploads/static-test.txt")

      assert text_response(conn, 200) == "uploaded file"
    end
  end
end
