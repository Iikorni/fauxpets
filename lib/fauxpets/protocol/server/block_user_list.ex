defmodule Fauxpets.Protocol.Server.BlockUserList do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [block_list: _block_list]) do
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C2E,
        Fauxpets.Protocol.Util.encode_short(0)))
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C2F, <<>>))
  end
end
