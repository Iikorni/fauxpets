defmodule Fauxpets.Protocol.Server.GV.Member do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, member_list: member_list) do
    Logger.info("GV.Member send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1D5B,
      Fauxpets.Protocol.Util.encode_short(0)))
  end
end
