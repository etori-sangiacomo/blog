defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  @valid_post %{
    title: "Phoenix",
    description: "Phoenix description"
  }

  @update_post %{
    title: "updated",
    description: "updated"
  }

  def fixture(:post) do
    user = Blog.Accounts.get_user!(1)
    {:ok, post} = Blog.Posts.create_post(user, @valid_post)
    post
  end

  describe "Posts" do
    setup [:create_post]

    test "list all posts", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ "Phoenix"
    end

    test "get post by id", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :show, post.id))
      assert html_response(conn, 200) =~ "Phoenix"
    end

    test "form post", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> get(Routes.post_path(conn, :new))

      assert html_response(conn, 200) =~ "Create Post"
    end

    test "form post withdraw user authenticated", %{conn: conn, post: post} do
      conn =
        conn
        |> get(Routes.post_path(conn, :new))

      assert redirected_to(conn) == Routes.page_path(conn, :index)

      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Require authentication!!"
    end

    test "create_post/1 with valid data", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> post(Routes.post_path(conn, :create), post: @valid_post)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Phoenix"
    end

    test "create_post/1 with invalid data returns error changeset", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> post(Routes.post_path(conn, :create), post: %{})

      assert html_response(conn, 200) =~ "be blank"
    end

    test "edit_post/1 with valid data", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> get(Routes.post_path(conn, :edit, post))

      assert html_response(conn, 200) =~ "Edit Post"
    end

    @tag :skip
    test "edit_post/1 with invalid user", %{conn: conn, post: post} do
      user = Blog.Accounts.get_user!(1)
      {:ok, post} = Blog.Posts.create_post(user, @valid_post)

      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 2)
        |> get(Routes.post_path(conn, :edit, post))

      assert redirected_to(conn) == Routes.page_path(conn, :index)

      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Permission denied!"
    end

    test "update_post/2 with valid data", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> put(Routes.post_path(conn, :update, post), post: @update_post)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "updated"
    end

    test "update_post/2 with invalid data", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> put(Routes.post_path(conn, :update, post), post: %{title: nil, description: nil})

      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "delete/1 post", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> delete(Routes.post_path(conn, :delete, post))

      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end

    defp create_post(_) do
      %{post: fixture(:post)}
    end
  end
end
