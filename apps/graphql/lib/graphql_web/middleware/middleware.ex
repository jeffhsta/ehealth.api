defmodule GraphQLWeb.Middleware do
  @moduledoc """
  This module sets schema-wide middleware.
  """

  defmacro __using__(opts \\ []) do
    authorization_meta_key = Keyword.get(opts, :authorization_meta_key, :scope)
    authorization_context_key = Keyword.get(opts, :authorization_context_key, :scope)

    quote do
      def middleware(middleware, %{__private__: [meta: [{unquote(authorization_meta_key), _}]]} = field, object) do
        opts = [
          meta_key: unquote(authorization_meta_key),
          context_key: unquote(authorization_context_key)
        ]

        [{GraphQLWeb.Middleware.Authorization, opts} | super(middleware, field, object)]
      end

      def middleware(middleware, field, object), do: super(middleware, field, object)

      defoverridable middleware: 3
    end
  end
end
