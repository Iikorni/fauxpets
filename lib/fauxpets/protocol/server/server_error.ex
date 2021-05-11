defmodule Fauxpets.Protocol.Server.ServerError do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, num: num) do
    Logger.info("ServerError send... (num: #{num})")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C1C,
      Fauxpets.Protocol.Util.encode_int(num)))
  end
end
