defmodule GraphQLWeb.Schema do
  use Absinthe.Schema
  use GraphQLWeb.Authz.Schema

  import_types(GraphQLWeb.Schema.PersonTypes)

  alias GraphQLWeb.Resolvers.{Person}

  query do
    @desc "Get all persons"
    field :persons, list_of(:person) do
      meta :scopes, ["person:list"]
      resolve(&Person.list_persons/3)
    end
  end
end
