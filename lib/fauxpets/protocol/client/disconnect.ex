defmodule Fauxpets.Protocol.Client.Disconnect do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def parse_packet(_data) do
    []
  end

  @impl true
  def handle_packet(socket, transport, _conn_state, _data) do
    Logger.info("Client has indicated disconnection")

    # TODO: There's probably a lot of stuff that should be handled here that
    # just plain isn't right now, becuase it's just one person testing at a time.

    :ok = transport.close(socket)
  end
end
