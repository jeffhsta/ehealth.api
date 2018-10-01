defmodule GraphQLWeb.Middleware.Authorization do
  @moduledoc """
  This middleware performs scope-based authorization on the fields.
  """

  @behaviour Absinthe.Middleware

  @forbidden_error_message "Your scope does not allow to access this resource"

  alias Absinthe.{Resolution, Type}

  def call(%{state: :unresolved} = resolution, opts) do
    [meta_key: meta_key, context_key: context_key] = opts

    requested_scopes = Type.meta(resolution.definition.schema_node, meta_key)
    available_scopes = Map.get(resolution.context, context_key, [])

    missing_scopes =
      [requested_scopes, available_scopes]
      |> Enum.map(&MapSet.new/1)
      |> (&apply(&2, &1)).(&MapSet.difference/2)
      |> MapSet.to_list()

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
