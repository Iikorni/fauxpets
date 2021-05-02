defmodule Fauxpets.Protocol.Server.LoginResponse do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  @impl true
  def send_packet(socket, transport, login_response: login_response) do
    Logger.info("LoginResponse send (login_response: #{inspect(login_response)})")

    packet = construct_login_response_packet(login_response)
    transport.send(socket, packet)
  end

  defp construct_login_response_packet(login_response) do
    case login_response do
      {:ok, user} ->
        Fauxpets.Protocol.Util.create_packet(
          0x1B5A,
          Fauxpets.Protocol.Util.encode_byte(0) <>
          Fauxpets.Protocol.Util.encode_int(user.id) <>
          Fauxpets.Protocol.Util.encode_string(user.username)
        )

      {:error, :bad_account} ->
        Fauxpets.Protocol.Util.create_packet(0x1B5A,
        Fauxpets.Protocol.Util.encode_byte(2))

      {:error, :bad_password} ->
        Fauxpets.Protocol.Util.create_packet(0x1B5A,
        Fauxpets.Protocol.Util.encode_byte(1))
    end
  end
end
