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

alias Blog.{Accounts, Accounts.User, Posts, Posts.Post}

user_params = %{
  email: "etori.sangiacomo@caminoeducation.com",
  first_name: nil,
  image: "https://lh3.googleusercontent.com/a/default-user=s96-c",
  last_name: nil,
  provider: "google",
  token: "ya29.a0AfH6SMCms_ePICDZJf5JZhB5YQX54LzJPeFkTOa2NhDWOQZ_NLMShOB3OQmCqEdZj9hqk7NHTh7B55mXxc9UvhYbqBoE6Wk0HeCRR5pBdu02inOYrigVQHnvD4prQ2L4JTkytURYHZ4fMyTT-o5Rv_4CpBgq"
}

post_params = %{title: "Pg", description: "Pg description"}

{:ok, user} = Blog.Accounts.create_user(user_params)
{:ok, post} = Posts.create_post(user, post_params)
