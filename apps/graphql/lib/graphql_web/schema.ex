defmodule GraphQLWeb.Schema do
  @moduledoc false

  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use GraphQLWeb.Middleware.MapGet
  use GraphQLWeb.Middleware.Authorization
  use GraphQLWeb.Middleware.ParseIDs
  use GraphQLWeb.Middleware.DatabaseIDs

  alias Core.LegalEntities.LegalEntity
  alias Core.Persons.Person

  import_types(GraphQLWeb.Schema.{
    AddressTypes,
    LegalEntityTypes,
    PersonTypes,
    PhoneTypes
  })

  query do
    import_fields(:legal_entity_queries)
    import_fields(:person_queries)
  end

  node interface do
    resolve_type(fn
      %LegalEntity{}, _ -> :legal_entity
      %Person{}, _ -> :person
      _, _ -> nil
    end)
  end
end
