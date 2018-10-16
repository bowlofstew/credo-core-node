defmodule CredoCoreNodeWeb.Router do
  use CredoCoreNodeWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/node_api/v1", as: :node_api_v1, alias: CredoCoreNodeWeb.NodeApi.V1 do
    pipe_through(:api)

    resources("/known_nodes", KnownNodeController, only: [:index])
    resources("/connections", ConnectionController, only: [:create])

    # Endpoints for temporary usage, to be replaced later with channels-based protocol
    scope "/temp", as: :temp, alias: Temp do
      resources("/pending_transactions", PendingTransactionController, only: [:create])
      resources("/votes", VoteController, only: [:create])
    end
  end
end
