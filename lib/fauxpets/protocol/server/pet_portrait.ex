defmodule Fauxpets.Protocol.Server.PetPortrait do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [pet_id: pet_id, revision: revision]) do
    Logger.info("PetPortrait send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BF5,
      Fauxpets.Protocol.Util.encode_int(pet_id) <>
      Fauxpets.Protocol.Util.encode_int(revision)))
  end
end
