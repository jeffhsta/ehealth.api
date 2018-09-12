use Mix.Config

config :graphql, GraphQLWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "example.com", port: 80]

config :logger, level: :info
