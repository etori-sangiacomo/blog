defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :description, :string

    has_many :comments, Blog.Comments.Comment
    timestamps()
  end

  @required ~w(title description)a
  @optional ~w()a
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end

  def changeset_update(post, attrs \\ %{}) do
    post
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
