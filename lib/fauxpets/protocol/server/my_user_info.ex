defmodule Fauxpets.Protocol.Server.MyUserInfo do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [user: user]) do
    Logger.info("MyUserInfo send: (user: #{inspect(user)})")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1bd1,
      Fauxpets.Protocol.Util.encode_int(user.id) <>
      Fauxpets.Protocol.Util.encode_int(2) <>
      Fauxpets.Protocol.Util.encode_int(0) <>
      Fauxpets.Protocol.Util.encode_byte(51) <>
      Fauxpets.Protocol.Util.encode_byte(0) <>
      Fauxpets.Protocol.Util.encode_byte(1) <>
      Fauxpets.Protocol.Util.encode_byte(0)
      ))
  end
end
