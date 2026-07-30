import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used

# In test we don't send emails
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :subject_manager, SubjectManager.Mailer, adapter: Swoosh.Adapters.Test

config :subject_manager, SubjectManager.Repo,
  database: Path.expand("../subject_manager_test.db", Path.dirname(__ENV__.file)),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 5,
  # We don't run a server during test. If one is required,
  # you can enable the server option below.
  pool: Ecto.Adapters.SQL.Sandbox

config :subject_manager, SubjectManagerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "d11LLBzOR0TqbcWVkjeiQ9scvycu1IbatIUo+y5H0IldLN/G5u+6ivXOKjiNNsxT",
  server: false

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false
