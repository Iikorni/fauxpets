defmodule Fauxpets.Protocol.Server.RecvMessage do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, name: name) do
    Logger.info("RecvMessage send... (name: #{name})")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BDE,
      Fauxpets.Protocol.Util.encode_string(name)))
  end
end
