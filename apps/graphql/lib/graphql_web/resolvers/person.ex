defmodule GraphQLWeb.Resolvers.Person do
  alias GraphQL.Person

  def list_persons(_parent, _args, _resolution) do
    {:ok, Person.list_persons()}
  end
end
