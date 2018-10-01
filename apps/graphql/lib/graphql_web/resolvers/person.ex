defmodule GraphQLWeb.Resolvers.Person do
  @moduledoc false

  alias GraphQL.Person

  def list_persons(_parent, _args, _resolution) do
    {:ok, Person.list_persons()}
  end

  def get_person_by(_parent, args, _resolution) do
    {:ok, Person.get_by(args)}
  end
end
