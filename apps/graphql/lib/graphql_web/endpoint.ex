defmodule GraphQLWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :graphql

  plug(Plug.RequestId)
  plug(Plug.LoggerJSON, level: Logger.level())

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(
    Absinthe.Plug,
    schema: GraphQLWeb.Schema,
    json_codec: Jason,
    context: %{scopes: ["person:read", "person:list"]}
  )

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
