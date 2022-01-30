import Config

config :frontend, FrontendWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

config :frontend, FrontendWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "safe-everglades-68157.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    """

config :dictionary, Dictionary.Repo,
  ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
