defmodule GraphQLWeb.Schema do
  @moduledoc false

  use Absinthe.Schema
  use GraphQLWeb.Middleware

  import_types(GraphQLWeb.Schema.{LegalEntityTypes, PersonTypes})

  query do
    import_fields(:legal_entity_queries)
    import_fields(:person_queries)
  end
end
