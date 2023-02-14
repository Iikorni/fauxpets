defmodule Fauxpets.Protocol.Server.PetAppearance do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [unk_a: unk_a, unk_b: unk_b]) do
    Logger.info("PetAppearancePe send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BF8,
      Fauxpets.Protocol.Util.encode_int(unk_a) <>
      Fauxpets.Protocol.Util.encode_int(unk_b)))
  end
end
