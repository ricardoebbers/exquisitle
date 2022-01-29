import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :frontend, FrontendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Pw8wA7awuYkmPyxPa1/hn0lNaICUCe3fK0Ytys4YX/SLR1RZIfWg9EFQn7Zd4axk",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
