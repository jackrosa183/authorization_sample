defmodule AuthorizationBlog.Repo do
  use Ecto.Repo,
    otp_app: :authorization_blog,
    adapter: Ecto.Adapters.Postgres
end
