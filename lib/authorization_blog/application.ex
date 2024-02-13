defmodule AuthorizationBlog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuthorizationBlogWeb.Telemetry,
      AuthorizationBlog.Repo,
      {DNSCluster, query: Application.get_env(:authorization_blog, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AuthorizationBlog.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AuthorizationBlog.Finch},
      # Start a worker by calling: AuthorizationBlog.Worker.start_link(arg)
      # {AuthorizationBlog.Worker, arg},
      # Start to serve requests, typically the last entry
      AuthorizationBlogWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthorizationBlog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthorizationBlogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
