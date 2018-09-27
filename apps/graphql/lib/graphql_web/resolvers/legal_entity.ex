defmodule GraphQLWeb.Resolvers.LegalEntity do
  alias Core.LegalEntities

  def list_legal_entities(_parent, args, _resolution) do
    {:ok, LegalEntities.list(args).entries}
  end

  def get_legal_entity_by_id(_parent, %{id: id}, _resolution) do
    {:ok, LegalEntities.get_by_id(id)}
  end
end
