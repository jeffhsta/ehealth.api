defmodule GraphQLWeb.Schema.LegalEntityTypes do
  @moduledoc false

  use Absinthe.Schema.Notation

  alias GraphQLWeb.Resolvers.LegalEntity

  object :legal_entity_queries do
    @desc "get list of Legal Entities"
    field :legal_entities, list_of(:legal_entity) do
      meta(:scope, ~w(legal_entity:list))
      arg(:first, :integer)
      arg(:skip, :integer)
      arg(:edrpou, :string)
      resolve(&LegalEntity.list_legal_entities/3)
    end

    @desc "get one Legal Entity by id"
    field :legal_entity, :legal_entity do
      arg(:id, non_null(:id))
      resolve(&LegalEntity.get_legal_entity_by_id/3)
    end
  end

  object :legal_entity do
    field(:id, :id)
    field(:name, :string)
    field(:public_name, :string)
    field(:short_name, :string)
    field(:edrpou, :string)

    field(:type, :legal_entity_type)
    field(:status, :legal_entity_status)

    #    field(:addresses, [Address)
  end

  enum :legal_entity_type do
    value(:mis, as: "MIS")
    value(:msp, as: "MSP")
    value(:pharmacy, as: "PHARMACY")
  end

  enum :legal_entity_status do
    value(:active, as: "ACTIVE")
    value(:closed, as: "CLOSED")
  end
end
