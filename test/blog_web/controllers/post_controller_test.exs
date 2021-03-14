defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  @valid_post %{
    title: "Phoenix",
    description: "Phoenix description"
  }

  test "list all posts", %{conn: conn} do
    Blog.Posts.create_post(@valid_post)
    conn = get(conn, Routes.post_path(conn, :index))
    assert html_response(conn, 200) =~ "Phoenix"
  end
end
