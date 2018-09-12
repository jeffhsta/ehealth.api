defmodule GraphQLWeb.Authz.Middleware do
  alias Absinthe.{Middleware, Resolution, Type}

  @behaviour Middleware

  @forbidden_error_message "Your scope does not allow to access this resource"

  def call(%{state: :unresolved} = resolution, config) do
    [meta_key: meta_key, context_key: context_key] = config

    requested_scopes = Type.meta(resolution.definition.schema_node, meta_key) |> MapSet.new()
    available_scopes = Map.get(resolution.context, context_key, []) |> MapSet.new()

    missing_scopes = MapSet.difference(requested_scopes, available_scopes) |> MapSet.to_list()

    if Enum.empty?(missing_scopes) do
      resolution
    else
      resolution
      |> Resolution.put_result({:error, format_forbidden_error(missing_scopes)})
    end
  end

  def call(res, _), do: res

  defp format_forbidden_error(missing_scopes) do
    %{
      message: @forbidden_error_message,
      extensions: %{code: "FORBIDDEN", exception: %{missingAllowances: missing_scopes}}
    }
  end
end
