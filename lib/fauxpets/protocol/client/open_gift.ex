defmodule Fauxpets.Protocol.Client.OpenGift do
  require Logger
  @behaviour Fauxpets.Protocol.ClientPacket

  @impl true
  def handle_packet(data) do
    {:ok, inv_no, rest} = Fauxpets.Protocol.Util.pop_short(data)
    {:ok, slot_index, _rest} = Fauxpets.Protocol.Util.pop_short(rest)
    [inv_no: inv_no, slot_index: slot_index]
  end
end
