defmodule GraphQLWeb.Schema do
  @moduledoc false

  alias Core.LegalEntities.LegalEntity
  alias Core.Persons.Person
  alias GraphQLWeb.Middleware

  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use Middleware.Authorization
  use Middleware.ParseIDs
  use Middleware.DatabaseIDs

  import_types(GraphQLWeb.Schema.{LegalEntityTypes, PersonTypes})

  query do
    import_fields(:legal_entity_queries)
    import_fields(:person_queries)
  end

  node interface do
    resolve_type(fn
      %LegalEntity{}, _ ->
        :legal_entity

      %Person{}, _ ->
        :person

      _, _ ->
        nil
    end)
  end
end
