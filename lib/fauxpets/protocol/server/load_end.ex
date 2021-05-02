defmodule Fauxpets.Protocol.Server.LoadEnd do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  @impl true
  def send_packet(socket, transport, []) do
    Logger.info("LoadEnd send")

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1d4d, <<>>))
  end
end
