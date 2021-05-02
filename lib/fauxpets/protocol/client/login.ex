defmodule Fauxpets.Protocol.Client.Login do
  @behaviour Fauxpets.Protocol.ClientPacket

  @impl true
  def handle_packet(data) do
    {:ok, username, rest} = Fauxpets.Protocol.Util.pop_string(data)
    {:ok, password_hash, _rest} = Fauxpets.Protocol.Util.pop_string(rest)

    [username: username, password_hash: password_hash]
  end
end
