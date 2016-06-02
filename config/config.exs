# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the namespace used by Phoenix generators
config :four_oh_four_finder,
  app_namespace: FourOhFourFinderApp

# Configures the endpoint
config :four_oh_four_finder, FourOhFourFinderApp.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "Kx1CwtepzH2XNFnrdT10aCFHy6OAIiKxVH7wfvGfc37BHVK5VWVxrna+90m7mQSX",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: FourOhFourFinderApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :new_relixir,
  application_name: System.get_env("NEW_RELIC_APP_NAME"),
  license_key: System.get_env("NEW_RELIC_LICENSE_KEY")

config :raygun,
    api_key: System.get_env("RAYGUN_APIKEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
