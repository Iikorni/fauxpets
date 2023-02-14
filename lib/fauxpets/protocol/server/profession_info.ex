defmodule Fauxpets.Protocol.Server.ProfessionInfo do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, _args) do
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C78,
        Fauxpets.Protocol.Util.encode_int(1) <>
        Fauxpets.Protocol.Util.encode_byte(100) <>
        Fauxpets.Protocol.Util.encode_short(100) <>
        Fauxpets.Protocol.Util.encode_byte(1) <>
        Fauxpets.Protocol.Util.encode_short(100)))
  end

  @spec append_admin(any, [atom | %{:id => integer, optional(any) => any}]) :: any
  def append_admin(packet, []) do
    packet
  end

  def append_admin(packet, [user | tail]) do
    packet = packet <> Fauxpets.Protocol.Util.encode_int(user.id)
    append_admin(packet, tail)
  end
end
