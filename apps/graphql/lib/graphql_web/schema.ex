defmodule GraphQLWeb.Schema do
  use Absinthe.Schema
  use GraphQLWeb.Authz.Schema

  import_types(GraphQLWeb.Schema.PersonTypes)
  import_types(GraphQLWeb.Schema.LegalEntityTypes)

  alias GraphQLWeb.Resolvers.Person

  query do
    @desc "Get all persons"
    field :persons, list_of(:person) do
      #      meta(:scopes, ["person:list"])
      resolve(&Person.list_persons/3)
    end

    @desc "Get person by id"
    field :person, :person do
      arg(:id, non_null(:id))
      #      arg :first_name, non_null(:first_name)
      resolve(&Person.get_person_by/3)
    end

    import_fields(:legal_entities_queries)
  end
end
