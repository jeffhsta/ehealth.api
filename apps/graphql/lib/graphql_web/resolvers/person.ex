defmodule GraphQLWeb.Resolvers.Person do
  def list_persons(_parent, _args, _resolution) do
    {:ok, GraphQL.Person.list_persons()}
  end
end
