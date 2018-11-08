defmodule CredoCoreNodeWeb.NodeApi.V1.ConnectionController do
  use CredoCoreNodeWeb, :controller

  require Logger

  alias CredoCoreNode.Network
  alias CredoCoreNodeWeb.Endpoint

  def create(conn, _params) do
    remote_ip =
      conn.remote_ip
      |> :inet_parse.ntoa()
      |> to_string()

    Logger.info("Incoming connection from #{remote_ip}")

    unless Network.get_known_node(remote_ip),
      do: Network.write_known_node(ip: remote_ip, is_seed: false)

    Network.retrieve_known_nodes(remote_ip)

    cond do
      Network.connected_to?(remote_ip) ->
        send_resp(conn, :found, "")

      Network.fully_connected?() ->
        send_resp(conn, :conflict, "")

      get_req_header(conn, "x-ccn-session-id") == Endpoint.config(:session_id) ->
        send_resp(conn, :forbidden, "")

      true ->
        Network.connect_to(remote_ip)
        send_resp(conn, :created, "")
    end
  end
end
