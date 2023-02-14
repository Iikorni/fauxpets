defmodule Fauxpets.Protocol.Server.PetList do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  @impl true
  def send_packet(socket, transport, [user_id: user_id, pet_list: pet_list]) do
    Logger.info("PetList send (user_id: #{user_id}, pet_list: #{inspect(pet_list)})")
    packet =
      Fauxpets.Protocol.Util.encode_int(user_id) <>
      Fauxpets.Protocol.Util.encode_short(length(pet_list)) <>
      Fauxpets.Protocol.Util.encode_byte(1)
    packet = append_pet_to_list(packet, 1, pet_list)
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BF7, packet))
  end

  def append_pet_to_list(packet, _index, []) do
    packet
  end

  def append_pet_to_list(packet, index, [pet | tail]) do
    packet = packet <>
      Fauxpets.Protocol.Util.encode_int(pet.id) <>
      Fauxpets.Protocol.Util.encode_string(pet.name) <>
      Fauxpets.Protocol.Util.encode_int(pet.portrait_no) <>
      Fauxpets.Protocol.Util.encode_byte(index) <>
      Fauxpets.Protocol.Util.encode_byte(0)
    append_pet_to_list(packet, index + 1, tail)
  end
end
