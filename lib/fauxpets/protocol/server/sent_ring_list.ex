defmodule Fauxpets.Protocol.Server.SentRingList do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  defp append_ring_send(packet, []) do
    packet
  end

  defp append_ring_send(packet, [send | tail]) do
    packet =
      packet <>
        Fauxpets.Protocol.Util.encode_int(send)
    append_ring_send(packet, tail)
  end

  def send_sent_ring_list(socket, transport, sent_ring_list) do
    packet =  Fauxpets.Protocol.Util.encode_short(length(sent_ring_list))

    packet = append_ring_send(packet, sent_ring_list)

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C4A, packet))
  end

  @impl true
  def send_packet(socket, transport, sent_ring_list: sent_ring_list) do
    Logger.info("SentRingList send")
    send_sent_ring_list(socket, transport, sent_ring_list)
  end

end
