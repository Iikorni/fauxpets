defmodule Fauxpets.Protocol.Server.GV.DesktopInfo do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, []) do
    Logger.info("GV.DesktopInfo send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1D65,
      Fauxpets.Protocol.Util.encode_int(1) <> # Land Number
      Fauxpets.Protocol.Util.encode_int(1) <> # Master Account No
      Fauxpets.Protocol.Util.encode_string("testland") <> # Land Name
      Fauxpets.Protocol.Util.encode_int(1) <> # Land Owner
      Fauxpets.Protocol.Util.encode_string("testland") <>
      Fauxpets.Protocol.Util.encode_byte(1) <> # Is Public Land?
      Fauxpets.Protocol.Util.encode_short(0) <> # Member Count
      Fauxpets.Protocol.Util.encode_short(10) <> # Max Member Count
      Fauxpets.Protocol.Util.encode_short(1) <> # Max Items?
      Fauxpets.Protocol.Util.encode_int(5001) <>
      Fauxpets.Protocol.Util.encode_int(0) <> # X
      Fauxpets.Protocol.Util.encode_int(0) <> # Y
      Fauxpets.Protocol.Util.encode_int(5) <>
      Fauxpets.Protocol.Util.encode_byte(0) <> # Is Sale Land?
      Fauxpets.Protocol.Util.encode_int(213554))) # Owner Photo No?
  end
end
