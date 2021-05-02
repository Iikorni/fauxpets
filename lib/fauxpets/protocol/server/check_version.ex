defmodule Fauxpets.Protocol.Server.CheckVersion do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, version: version) do
    Logger.info("CheckVersion send (version: #{version})")
    transport.send(
      socket,
      Fauxpets.Protocol.Util.create_packet(
        0x1B59,
        <<version::size(4)-unit(8)-unsigned-integer-little>>
      )
    )
  end
end
