defmodule Greeter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GreeterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Greeter.PubSub},
      # Start the Endpoint (http/https)
      GreeterWeb.Endpoint
      # Start a worker by calling: Greeter.Worker.start_link(arg)
      # {Greeter.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Greeter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GreeterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
