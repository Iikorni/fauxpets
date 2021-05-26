defmodule Fauxpets.Protocol.Server.SendFriendshipRing do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def get_ring_res(res) do
    case res do
      :ok -> 0x0000
      :maxsend_over -> 0x0001
      :maxrecv_over -> 0x0002
      :no_money -> 0x0003
      :already_given -> 0x0004
      :blocked -> 0x0005
      :blocking -> 0x0006
      :error -> 0x0007
    end
  end

  def send_packet(socket, transport, [res: res]) do
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C5D,
        Fauxpets.Protocol.Util.encode_short(get_ring_res(res))))
  end
end
