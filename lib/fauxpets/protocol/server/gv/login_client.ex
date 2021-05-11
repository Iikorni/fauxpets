defmodule Fauxpets.Protocol.Server.GV.LoginClient do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, []) do
    Logger.info("GV.LoginClient send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1D5E,
      Fauxpets.Protocol.Util.encode_byte(0)))
  end
end
