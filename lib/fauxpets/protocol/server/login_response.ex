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
        user_id = <<user.id::integer-size(4)-unit(8)>>

        Fauxpets.Protocol.Util.create_packet(
          0x1B5A,
          <<0x00::size(1)-unit(8)>> <>
            user_id <> Fauxpets.Protocol.Util.encode_string(user.username)
        )

      {:error, :bad_account} ->
        Fauxpets.Protocol.Util.create_packet(0x1B5A, <<0x02::size(1)-unit(8)>>)

      {:error, :bad_password} ->
        Fauxpets.Protocol.Util.create_packet(0x1B5A, <<0x01::size(1)-unit(8)>>)
    end
  end
end
