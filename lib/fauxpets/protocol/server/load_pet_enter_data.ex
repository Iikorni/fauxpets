defmodule Fauxpets.Protocol.Server.LoadPetEnterData do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, []) do
    Logger.info("LoadPetEnterData send...")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1D50,
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_byte(0) <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_string("Dipshit") <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_string("test1") <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_int(0) <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_int(1)))
  end
end
