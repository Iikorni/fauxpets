defmodule Fauxpets.Protocol.Server.BoxList do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [box_list: box_list]) do
    Logger.info("BoxList send (box_list: #{inspect(box_list)})")
    packet =
      Fauxpets.Protocol.Util.encode_short(length(box_list))
    packet = append_box_to_list(packet, 0, box_list)
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BFD, packet))
  end

  def append_box_to_list(packet, _index, []) do
    packet
  end

  def append_box_to_list(packet, index, [box | tail]) do
    packet = packet <>
      Fauxpets.Protocol.Util.encode_short(index) <>
      Fauxpets.Protocol.Util.encode_string(box.name)
    append_box_to_list(packet, index + 1, tail)
  end
end
