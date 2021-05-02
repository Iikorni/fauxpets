defmodule Fauxpets.Protocol.Client.ClientInfo do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def handle_packet(data) do
    <<id::size(2)-unit(8)-unsigned-integer-little, _rest::binary>> = data
    case id do
      0x0000 ->
        [resp: {:ok, :client_login_ok}]
      0x0001 ->
        [resp: {:ok, :client_window_close}]
      _ ->
        [resp: {:error, :unknown_code, data}]
    end
  end
end
