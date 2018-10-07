defmodule GraphQLWeb.Resolvers.Person do
  @moduledoc false

  import Core.Utils.TypesConverter, only: [strings_to_keys: 1]

  alias Core.Persons

  def list_persons(_parent, _args, _resolution) do
    {:ok, []}
  end

  def get_person_by_id(_parent, %{id: id}, %{context: %{headers: headers}}) do
    case Persons.get_by_id(id, headers) do
      {:ok, person} ->
        {:ok, strings_to_keys(person)}

      # TODO: return better error message
      _ ->
        {:error, "Failed to get Person with ID #{id}"}
    end
  end
end
