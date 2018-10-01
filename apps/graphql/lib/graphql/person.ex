defmodule GraphQL.Person do
  @moduledoc false

  @persons %{
    "1" => %{id: 1, first_name: "John", last_name: "Doe"},
    "2" => %{id: 2, first_name: "Jane", last_name: "Roe"}
  }

  def list_persons do
    Map.values(@persons)
  end

  def get_by(args) do
    Map.get(@persons, args.id)
  end
end
