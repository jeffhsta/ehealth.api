defmodule GraphQLWeb.PersonResolverTest do
  use GraphQLWeb.ConnCase, async: true

  describe "persons list" do
    test "success", %{conn: conn} do
      query = """
        {
          persons {
            id
            first_name
          }
        }
      """

      data =
        conn
        |> post(graphql_path(), %{query: query})
        |> json_response(200)
        |> Map.get("data")

      assert %{"persons" => persons} = data
      assert 2 == length(persons)
    end
  end

  describe "get by id" do
    setup do
      {:ok, person: %{id: "2"}}
    end

    test "list", %{conn: conn, person: person} do
      query = """
        {
          person(id: #{person.id}) {
            id
            first_name
          }
        }
      """

      resp =
        conn
        |> post(graphql_path(), %{query: query})
        |> json_response(200)
    end
  end
end
