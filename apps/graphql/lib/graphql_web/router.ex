defmodule GraphQLWeb.Router do
  use GraphQLWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", GraphQLWeb do
    pipe_through(:api)
  end
end
