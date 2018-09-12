defmodule GraphQLWeb.Authz.Schema do
  defmacro __using__(opts \\ []) do
    meta_key = Keyword.get(opts, :meta_key, :scopes)
    context_key = Keyword.get(opts, :context_key, :scopes)

    quote do
      def middleware(middleware, %{__private__: [meta: [{unquote(meta_key), _}]]} = field, object),
        do: [
          {GraphQLWeb.Authz.Middleware, [meta_key: unquote(meta_key), context_key: unquote(context_key)]}
          | super(middleware, field, object)
        ]

      def middleware(middleware, field, object), do: super(middleware, field, object)

      defoverridable middleware: 3
    end
  end
end
