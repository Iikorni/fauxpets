defmodule Fauxpets.Protocol.Server.Level do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [level: level, exp: exp]) do
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C31,
        Fauxpets.Protocol.Util.encode_byte(level) <>
        Fauxpets.Protocol.Util.encode_int(exp)))
  end
end
