# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :bird_app_ui, BirdAppUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uksyOXmPTcqnZU3GVwcfO0Y+kApe9w6DztgHljcOgz6PfSocXQg8uLCNBK/xnENj",
  render_errors: [view: BirdAppUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: BirdAppUi.PubSub,
  live_view: [signing_salt: "POwlTpcq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :nadia,
  token: System.get_env("TELEGRAM_BOT_TOKEN"),
  chat_id: System.get_env("TELEGRAM_CHAT_ID"),
  chat_url: System.get_env("TELEGRAM_CHAT_URL")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
