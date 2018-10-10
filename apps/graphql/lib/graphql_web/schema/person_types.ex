defmodule GraphQLWeb.Schema.PersonTypes do
  @moduledoc false

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias GraphQLWeb.Resolvers.Person

  object :person_queries do
    @desc "Get all persons"
    connection field(:persons, node_type: :person) do
      meta(:scope, ~w(person:list))
      arg(:filter, :person_filter)
      arg(:orderBy, :person_order_by)
      resolve(&Person.list_persons/3)
    end

    @desc "Get person by id"
    field(:person, :person) do
      arg(:id, non_null(:id))
      meta(:scope, ~w(person:read))
      resolve(&Person.get_person_by_id/3)
    end
  end

  input_object(:person_filter) do
    field(:tax_id, :string)
    field(:unzr, :string)
    field(:phone_number, :string)
    field(:personal, :person_personal_filter)
  end

  input_object :person_personal_filter do
    field(:first_name, non_null(:string))
    field(:last_name, non_null(:string))
    # TODO: this field should be :date scalar type
    field(:birth_date, non_null(:string))
  end

  enum :person_order_by do
    value(:birth_date_asc)
    value(:birth_date_desc)
    value(:inserted_at_asc)
    value(:inserted_at_desc)
    value(:tax_id_asc)
    value(:tax_id_desc)
    value(:unzr_asc)
    value(:unzr_desc)
  end

  connection node_type: :person do
    field :nodes, list_of(:person) do
      resolve(fn
        _, %{source: conn} ->
          nodes = conn.edges |> Enum.map(& &1.node)
          {:ok, nodes}
      end)
    end

    edge(do: nil)
  end

  node object(:person) do
    field(:database_id, non_null(:id))
    field(:first_name, non_null(:string))
    field(:last_name, non_null(:string))
    field(:second_name, :string)
    # TODO: this field should be :date scalar type
    field(:birth_date, :string)
    field(:gender, non_null(:person_gender))
    field(:status, non_null(:person_status))
    field(:birth_country, non_null(:string))
    field(:birth_settlement, non_null(:string))
    field(:tax_id, :string)
    field(:no_tax_id, non_null(:boolean))
    field(:unzr, :string)
    field(:preferred_way_communication, :person_preferred_way_communication)
    # TODO: this field should be :date_time scalar type
    field(:inserted_at, non_null(:string))
    # TODO: this field should be :date_time scalar type
    field(:updated_at, non_null(:string))
    field(:authentication_methods, non_null(list_of(:person_authentication_method)))
    field(:documents, list_of(:person_document))
    field(:addresses, non_null(list_of(:address)))
    field(:phones, list_of(:phone))
    # field :declarations, list_of(:declaration) do
    #   arg(:filter, :declaration_filter)
    #   arg(:order_by, :declaration_order_by)
    # end
  end

  enum :person_gender do
    value(:male, as: "MALE")
    value(:female, as: "FEMALE")
  end

  # TODO: This enum should map to upper-case values
  enum :person_status do
    value(:active, as: "active")
    value(:inactive, as: "inactive")
  end

  # TODO: This enum should map to upper-case values
  enum :person_preferred_way_communication do
    value(:email, as: "email")
    value(:phone, as: "phone")
  end

  object :person_document do
    field(:type, :string)
    field(:number, :string)
    field(:issued_by, :string)
    # TODO: this field should be serialized into :date scalar type
    field(:issued_at, :string)
  end

  object(:person_authentication_method) do
    field(:type, non_null(:person_authentication_method_type))
    field(:phone_number, :string)
  end

  enum :person_authentication_method_type do
    value(:otp, as: "OTP")
    value(:offline, as: "OFFLINE")
    value(:na, as: "NA")
  end

  # TODO: move this object into own file
  object :address do
    field(:type, non_null(:address_type))
    field(:country, non_null(:string))
    field(:area, non_null(:string))
    field(:region, :string)
    field(:settlement, non_null(:string))
    field(:settlement_type, non_null(:string))
    field(:settlement_id, non_null(:id))
    field(:street_type, :string)
    field(:street, :string)
    field(:building, non_null(:string))
    field(:apartment, :string)
    field(:zip, non_null(:string))
  end

  # TODO: move this enum into own file
  enum :address_type do
    value(:residence, as: "RESIDENCE")
    value(:registration, as: "REGISTRATION")
  end

  # TODO: move this object into own file
  object :phone do
    field(:type, non_null(:phone_type))
    field(:number, non_null(:string))
  end

  # TODO: move this enum into own file
  enum :phone_type do
    value(:mobile, as: "MOBILE")
    value(:land_line, as: "LAND_LINE")
  end
end
