defmodule Fauxpets.Protocol.Client.RequestInventory do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def parse_packet(data) do
    {:ok, inv_no, _rest} = Fauxpets.Protocol.Util.pop_short(data)
    [inv_no: inv_no]
  end

  @impl true
  def handle_packet(socket, transport, conn_state, [inv_no: inv_no]) do
    Logger.info("Client wants information for the inventory '#{inv_no}'")

    user = Fauxpets.ConnectionState.get_user(conn_state)

    Fauxpets.Protocol.Server.InventoryList.send_packet(socket, transport,
     inv_no: inv_no,
     box: Enum.at(user.boxes, inv_no)
    )
  end
end
