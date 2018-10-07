defmodule GraphQLWeb.PersonResolverTest do
  use GraphQLWeb.ConnCase, async: true

  import Mox

  alias Ecto.UUID
  alias Absinthe.Relay.Node

  setup context do
    conn = put_scope(context.conn, "person:read person:list")

    {:ok, %{conn: conn}}
  end

  setup :verify_on_exit!

  # describe "persons list" do
  #   test "success", %{conn: conn} do
  #     query = """
  #       {
  #         persons {
  #           id
  #           first_name
  #         }
  #       }
  #     """

  #     data =
  #       conn
  #       |> post_query(query)
  #       |> json_response(200)
  #       |> Map.get("data")

  #     assert %{"persons" => persons} = data
  #     assert 2 == length(persons)
  #   end
  # end

  describe "get by id" do
    test "success", %{conn: conn} do
      database_id = UUID.generate()
      id = Node.to_global_id("Person", database_id)

      expect(MPIMock, :person, fn id, _headers ->
        get_person(id, 200)
      end)

      query = """
        query PersonQuery($id: ID!) {
          person(id: $id) {
            id
            databaseId
            firstName
            lastName
            secondName
            birthDate
            gender
            status
            birthCountry
            birthSettlement
            taxId
            unzr
            preferredWayCommunication
            insertedAt
            documents {
              type
              number
              issuedBy
              issuedAt
            }
            authenticationMethods {
              type
              phoneNumber
            }
            addresses {
              type
              country
              area
              region
              settlement
              settlementType
              settlementId
              streetType
              street
              building
              apartment
              zip
            }
            phones {
              type
              number
            }
            # declarations
          }
        }
      """

      variables = %{id: id}

      resp_body =
        conn
        |> post_query(query, variables)
        |> json_response(200)

      resp_entity = get_in(resp_body, ~w(data person))

      assert nil == resp_body["errors"]
      assert id == resp_entity["id"]
      assert database_id == resp_entity["databaseId"]

      assert Enum.all?(
               ~w(firstName lastName secondName birthDate gender status birthCountry birthSettlement taxId unzr preferredWayCommunication insertedAt documents addresses phones authenticationMethods),
               &Map.has_key?(resp_entity, &1)
             )

      Enum.each(resp_entity["documents"], fn document ->
        assert Enum.all?(
                 ~w(type number issuedBy issuedAt),
                 &Map.has_key?(document, &1)
               )
      end)

      Enum.each(resp_entity["authenticationMethods"], fn authentication_method ->
        assert Enum.all?(
                 ~w(type phoneNumber),
                 &Map.has_key?(authentication_method, &1)
               )
      end)

      Enum.each(resp_entity["addresses"], fn address ->
        assert Enum.all?(
                 ~w(type country area region settlement settlementType settlementId streetType street building apartment zip),
                 &Map.has_key?(address, &1)
               )
      end)

      Enum.each(resp_entity["phones"], fn phone ->
        assert Enum.all?(
                 ~w(type number),
                 &Map.has_key?(phone, &1)
               )
      end)
    end
  end

  defp get_person(id, status, params \\ %{}) do
    params = Map.put(params, :id, id)

    person =
      build(:person, params)
      |> Jason.encode!()
      |> Jason.decode!()

    {:ok, %{"data" => person, "meta" => %{"code" => status}}}
  end
end
