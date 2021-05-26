defmodule Fauxpets.Protocol.Client.RequestUser do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def handle_packet(data) do
    {:ok, name, _rest} = Fauxpets.Protocol.Util.pop_string(data)
    [resp: [name: name]]
  end
end
