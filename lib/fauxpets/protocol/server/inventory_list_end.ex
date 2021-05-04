defmodule Fauxpets.Protocol.Server.InventoryListEnd do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, []) do
    Logger.info("InventoryList send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C21, <<>>))
  end
end
