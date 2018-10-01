defmodule GraphQLWeb.LegalEntityResolverTest do
  use GraphQLWeb.ConnCase, async: true
  import Core.Factories

  setup context do
    conn = put_scope(context.conn, "legal_entity:read legal_entity:list")

    {:ok, %{conn: conn}}
  end

  describe "list" do
    test "success without params", %{conn: conn} do
      insert(:prm, :legal_entity)
      insert(:prm, :legal_entity)

      query = """
        {
          legal_entities {
            id
            public_name
          }
        }
      """

      data =
        conn
        |> post_query(query)
        |> json_response(200)
        |> Map.get("data")

      assert %{"legal_entities" => legal_entities} = data
      assert 2 == length(legal_entities)

      Enum.each(legal_entities, fn legal_entity ->
        assert Map.has_key?(legal_entity, "id")
        assert Map.has_key?(legal_entity, "public_name")
      end)
    end

    test "filter by edrpou", %{conn: conn} do
      insert(:prm, :legal_entity, edrpou: "1234567890")
      insert(:prm, :legal_entity, edrpou: "0987654321")

      query = """
        {
          legal_entities(edrpou: "1234567890") {
            id
            edrpou
            public_name
          }
        }
      """

      data =
        conn
        |> post_query(query)
        |> json_response(200)
        |> Map.get("data")

      assert %{"legal_entities" => legal_entities} = data
      assert 1 == length(legal_entities)
      assert "1234567890" == hd(legal_entities)["edrpou"]
    end
  end

  describe "get by id" do
    test "success", %{conn: conn} do
      insert(:prm, :legal_entity)
      legal_entity = insert(:prm, :legal_entity)

      query = """
        {
          legal_entity(id: "#{legal_entity.id}") {
            id
            public_name
          }
        }
      """

      resp =
        conn
        |> post_query(query)
        |> json_response(200)
        |> get_in(~w(data legal_entity))

      assert legal_entity.public_name == resp["public_name"]
    end
  end
end
