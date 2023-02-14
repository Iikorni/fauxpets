defmodule Fauxpets.Protocol.Client.OpenGift do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def parse_packet(data) do
    {:ok, inv_no, rest} = Fauxpets.Protocol.Util.pop_short(data)
    {:ok, slot_index, _rest} = Fauxpets.Protocol.Util.pop_short(rest)
    [inv_no: inv_no, slot_index: slot_index]
  end

  @impl true
  def handle_packet(socket, transport, _conn_state, [inv_no: inv_no, slot_index: slot_index]) do
    Logger.info("Got gift open! (Inventory #{inv_no}, Slot #{slot_index})")

    Fauxpets.Protocol.Server.OpenGiftItem.send_packet(socket, transport,
      inv_no: inv_no,
      slot_index: slot_index
    )
  end
end
