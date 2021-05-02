defmodule Fauxpets.Protocol.Server.StartStream do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  @impl true
  def send_packet(socket, transport, salt: salt) do
    Logger.info("StartStream send (salt: #{salt})")

    transport.send(
      socket,
      Fauxpets.Protocol.Util.create_packet(0x1B5D, Fauxpets.Protocol.Util.encode_string(salt))
    )
  end
end
