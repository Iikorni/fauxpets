defmodule Fauxpets.Protocol.Server.UsersInfo do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  defp append_users(packet, []) do
    packet
  end

  defp append_users(packet, [user | tail]) do
    packet =
      packet <>
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

      append_users(packet, tail)
  end


  def send_user_list_packet(socket, transport, user_list) do
    packet = Fauxpets.Protocol.Util.encode_short(length(user_list))

    packet = append_users(packet, user_list)

    Logger.info("(user: #{inspect(packet)})")

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C02, packet))
  end

  @impl true
  def send_packet(socket, transport, user_list: user_list) do
    Logger.info("UsersInfo send")
    send_user_list_packet(socket, transport, user_list)
  end

end
