import Config

if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :frontend, FrontendWeb.Endpoint, server: true
end

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  port =
    System.get_env("PORT") ||
      raise """
      environment variable PORT is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :frontend, FrontendWeb.Endpoint,
    url: [scheme: "https", host: "safe-everglades-68157.herokuapp.com", port: port],
    secret_key_base: secret_key_base

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      """

  config :dictionary, Dictionary.Repo,
    ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end
