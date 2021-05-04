defmodule Fauxpets.Protocol.Server.InventoryListStart do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [inv_no: inv_no]) do
    Logger.info("InventoryList send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BCD,
      Fauxpets.Protocol.Util.encode_short(inv_no) <>
      Fauxpets.Protocol.Util.encode_string("Test Box")
    ))
  end
end
