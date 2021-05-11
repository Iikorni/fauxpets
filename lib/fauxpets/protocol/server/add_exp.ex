defmodule Fauxpets.Protocol.Server.AddExp do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [exp: exp]) do
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C36,
        Fauxpets.Protocol.Util.encode_int(exp)))
  end
end
