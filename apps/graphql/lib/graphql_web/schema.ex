defmodule GraphQLWeb.Schema do
  use Absinthe.Schema

  import_types(GraphQLWeb.Schema.PersonTypes)

  alias GraphQLWeb.Resolvers

  query do
    @desc "Get all persons"
    field :persons, list_of(:person) do
      resolve(&Resolvers.Person.list_persons/3)
    end
  end
end
