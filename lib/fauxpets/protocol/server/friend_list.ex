defmodule Fauxpets.Protocol.Server.FriendList do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  defp get_friend_type(type) do
    case type do
      :admin -> 0
      :best_friend -> 1
      :friend -> 2
      :fo_friend -> 3
      :unknown -> 4
    end
  end

  defp append_friend(packet, []) do
    packet
  end

  defp append_friend(packet, [friend | tail]) do
    packet =
      packet <>
        Fauxpets.Protocol.Util.encode_byte(get_friend_type(friend[:type])) <>
        Fauxpets.Protocol.Util.encode_int(friend[:id])
    append_friend(packet, tail)
  end

  def send_friend_list(socket, transport, friend_list) do
    packet =  Fauxpets.Protocol.Util.encode_short(length(friend_list))

    packet = append_friend(packet, friend_list)

    Logger.info("friendslist packet looks like #{inspect(packet, binaries: :as_binaries)}")

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BC7, packet))
  end

  @impl true
  def send_packet(socket, transport, [user: user, friend_list: friend_list]) do
    Logger.info("FriendListStart send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BC8,
      Fauxpets.Protocol.Util.encode_byte(1) <>
      Fauxpets.Protocol.Util.encode_int(user.id) <>
      Fauxpets.Protocol.Util.encode_string(user.username)
    ))

    Logger.info("FriendList send")
    send_friend_list(socket, transport, friend_list)

    Logger.info("FriendListEnd send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C22, <<>>))
  end

end
