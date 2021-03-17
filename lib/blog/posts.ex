defmodule Blog.Posts do
  alias Blog.{Posts, Posts.Post, Repo}

  def list_posts, do: Repo.all(Post)

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs \\ %{}) do
    Post.changeset(attrs)
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