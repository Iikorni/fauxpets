defmodule Fauxpets.Protocol.Server.UserInfo do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket





  def send_user_list_packet(socket, transport, user) do
    packet =
      Fauxpets.Protocol.Util.encode_int(user[:id]) <>
      Fauxpets.Protocol.Util.encode_string(user[:username]) <>
      Fauxpets.Protocol.Util.encode_byte(4) <> # Friendship Status ??????
      Fauxpets.Protocol.Util.encode_string("testtest") <> # Unknown
      Fauxpets.Protocol.Util.encode_int(0) <> # User Photo ID
      Fauxpets.Protocol.Util.encode_byte(3) <>
      Fauxpets.Protocol.Util.encode_bool(false) <> # Safe Mode
      Fauxpets.Protocol.Util.encode_int(2) <> # Language ID
      Fauxpets.Protocol.Util.encode_string("1992-05-25") <> # Birthdate?
      Fauxpets.Protocol.Util.encode_bool(false) # Is Premium

    Logger.info("(user: #{inspect(packet)})")

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C02, packet))
  end

  @impl true
  def send_packet(socket, transport, user_list: user_list) do
    Logger.info("UsersInfo send")
    send_user_list_packet(socket, transport, user_list)
  end

end
