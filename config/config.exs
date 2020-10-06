# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :greeter, GreeterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CN6L3hU7PpTVJjU+jcHhlkhTr2uumyJT2QWAnQ6N1yRHLtxCeEi6yVn83XXDkwTN",
  render_errors: [view: GreeterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Greeter.PubSub,
  live_view: [signing_salt: "ry2sFRrL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
