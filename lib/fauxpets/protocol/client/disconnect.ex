defmodule Fauxpets.Protocol.Client.Disconnect do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def handle_packet(_data) do
    Logger.info("Client has indicated disconnection")
    []
  end
end
