defmodule Fauxpets.Protocol.Server.AdminList do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [admins: admins]) do
    packet = Fauxpets.Protocol.Util.encode_short(length(admins))
    packet = append_admin(packet, admins)

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1c3c, packet))
  end

  def append_admin(packet, []) do
    packet
  end

  def append_admin(packet, [user | tail]) do
    packet = packet <> Fauxpets.Protocol.Util.encode_int(user.id)
    append_admin(packet, tail)
  end
end
