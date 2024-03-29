# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hello,
  ecto_repos: [Hello.Repo]

# Configures the endpoint
config :hello, HelloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "69s4rdL6obieeeLQfppdoHiZBikoAsBZjNOvRuADChdz2qIk400hBWooB86/i0Ja",
  render_errors: [view: HelloWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hello.PubSub,
  live_view: [signing_salt: "QaLgGwq9"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian
config :hello, Hello.UserManager.Guardian,
  issuer: "hello",
  secret_key: "krd6tFULWrVXd3jTQCSR7uafnrzQZDaqo/YFul5jNTQYKePI76SCMVRraRchFeVe"

config :hello, HelloWeb.Endpoint,
  live_view: [signing_salt: "SECRET_SALT"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
