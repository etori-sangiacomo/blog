# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Blog.{Repo, Posts.Post}

phoenix = Post.changeset(%{title: "Phoenix", description: "Phoenix description"})
pg = Post.changeset(%{title: "Pg", description: "Pg description"})

Repo.insert!(phoenix)
Repo.insert!(pg)
