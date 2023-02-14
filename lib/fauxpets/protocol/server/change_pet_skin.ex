defmodule Fauxpets.Protocol.Server.ChangePetSkin do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, _args) do
    Logger.info("ChangePetSkin send")

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BEF,
        Fauxpets.Protocol.Util.encode_int(1) <>
        Fauxpets.Protocol.Util.encode_string("3;") <>
        Fauxpets.Protocol.Util.encode_int(0x0A) <>
        Fauxpets.Protocol.Util.encode_int(1) <>
        Fauxpets.Protocol.Util.encode_int(0x000202FE) <>
        Fauxpets.Protocol.Util.encode_string("3;") <>
        Fauxpets.Protocol.Util.encode_int(1) <>
        Fauxpets.Protocol.Util.encode_int(0x00FB0202) <>
        Fauxpets.Protocol.Util.encode_int(1) <>
        Fauxpets.Protocol.Util.encode_int(0x0002fe02) <>
        Fauxpets.Protocol.Util.encode_int(0)))
  end
end
