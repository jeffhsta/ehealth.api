defmodule GraphQL.Person do
  @persons %{
    "foo" => %{id: "foo", first_name: "John", last_name: "Doe"},
    "bar" => %{id: "bar", first_name: "Jane", last_name: "Roe"}
  }

  def list_persons do
    Map.values(@persons)
  end
end
