defmodule Fauxpets.Protocol.Server.Notice do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  @impl true
  def send_packet(socket, transport, msg: msg) do
    transport.send(
      socket,
      Fauxpets.Protocol.Util.create_packet(
        0x1BD2,
        Fauxpets.Protocol.Util.encode_string(msg)
      )
    )
  end
end
