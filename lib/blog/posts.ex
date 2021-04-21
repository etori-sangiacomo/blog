defmodule Blog.Posts do

  import Ecto.Query, warn: false
  alias Blog.{Posts, Posts.Post, Repo}

  def list_posts(user_id) do
    Post
    |> where([p], p.user_id == ^user_id)
    |> Repo.all
  end

  def list_posts(), do: Repo.all(Post)

  def get_post!(id), do: Repo.get!(Post, id)

  def get_post_with_comments(id) do
    Repo.get!(Post, id) |> Repo.preload(comments: [:user])
  end

  def create_post(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:posts)
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(post, post_params) do
    post
    |> Post.changeset_update(post_params)
    |> Repo.update()
  end

  def delete(id) do
    get_post!(id)
    |> Repo.delete!()
  end
end
