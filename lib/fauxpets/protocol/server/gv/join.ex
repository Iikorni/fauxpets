defmodule Fauxpets.Protocol.Server.GV.Join do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, []) do
    Logger.info("GV.Join send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1D59,
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_int(1)))
  end
end
