defmodule Fauxpets.Protocol.Client.QuestInfo do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def parse_packet(data) do
    {:ok, quest_no, _rest} = Fauxpets.Protocol.Util.pop_int(data)
    [quest_no: quest_no]
  end

  @impl true
  def handle_packet(_socket, _transport, _conn_state, [quest_no: quest_no]) do
    Logger.info("Client wants info about quest '#{quest_no}'")

    # TODO: Do something w/ this
  end
end
