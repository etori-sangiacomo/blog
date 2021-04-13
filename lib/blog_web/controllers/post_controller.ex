defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.{Posts, Posts.Post}
  plug BlogWeb.Plug.RequireAuth when action in [:create, :new, :edit, :update, :delete]
  plug :check_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def new(conn, params) do
    changeset = Post.changeset(%{})
    render(conn, "new.html", changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Post.changeset_update(post)

    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def create(conn, %{"post" => post}) do
    case Posts.create_post(conn.assigns[:user], post) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created sucessfully!")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated sucessfully!")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    Posts.delete(id)

    conn
    |> put_flash(:info, "Post deleted successfully!")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def check_owner(%{params: %{"id" => post_id}} = conn, _) do
    case Posts.get_post!(post_id).user_id == conn.assigns.user.id do
      true ->
        conn

      false ->
        conn
        |> put_flash(:error, "Permission denied!")
        |> redirect(to: Routes.post_path(conn, :index))
        |> halt()
    end
  end
end
