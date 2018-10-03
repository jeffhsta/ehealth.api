defmodule GraphQLWeb.Middleware.MapGet do
  @moduledoc """
  This middleware fetches field values from the resolver result
  """

  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution

  defmacro __using__(_) do
    quote do
      def middleware(middleware, field, object) do
        middleware = super(middleware, field, object)

        Absinthe.Schema.replace_default(middleware, {unquote(__MODULE__), field.identifier}, field, object)
      end

      defoverridable middleware: 3
    end
  end

  def call(%{source: source} = resolution, key) do
    value = Map.get(source, key) || Map.get(source, to_string(key))

    Resolution.put_result(resolution, {:ok, value})
  end
end
