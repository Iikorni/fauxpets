defmodule Fauxpets.Protocol.Client.RequestUser do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def parse_packet(data) do
    {:ok, name, _rest} = Fauxpets.Protocol.Util.pop_string(data)
    [name: name]
  end

  @impl true
  def handle_packet(_socket, _transport, _conn_state, [name: name]) do
    Logger.info("Client wants information for the user '#{name}'")

    # TODO: Do something with this
  end
end
