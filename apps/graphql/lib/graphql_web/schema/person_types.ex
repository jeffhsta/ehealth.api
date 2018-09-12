defmodule GraphQLWeb.Schema.PersonTypes do
  use Absinthe.Schema.Notation

  object :person do
    field(:id, :id)
    field(:first_name, :string)
    field(:last_name, :string)
  end
end
