defmodule Fauxpets.Protocol do
  require Logger
  require Ecto.Query

  @behaviour :ranch_protocol

  def start_link(ref, transport, protocolOptions) do
    pid = spawn_link(__MODULE__, :init, [ref, transport, protocolOptions])
    {:ok, pid}
  end

  def init(ref, transport, _protocolOptions) do
    {:ok, socket} = :ranch.handshake(ref)
    Logger.info("Recieved client connection - sending check version and stream...")
    Fauxpets.Protocol.Server.StartStream.send_packet(socket, transport, salt: "SALT")
    Fauxpets.Protocol.Server.CheckVersion.send_packet(socket, transport, version: 0x34)
    {:ok, bucket} = GenServer.start_link(Fauxpets.ProtocolBucket, :ok)
    loop(socket, transport, bucket)
  end

  def loop(socket, transport, bucket) do
    case transport.recv(socket, 0, 60000) do
      {:ok, data} ->
        parser(data, socket, transport, bucket)
        loop(socket, transport, bucket)

      _ ->
        Logger.info("closing client connection...")
        :ok = transport.close(socket)
    end
  end

  def packet_type(packet_id) do
    case packet_id do
      0x138A ->
        {:ok, :login}

      0x138C ->
        {:ok, :client_disconnect}

      0x1421 ->
        {:ok, :client_interaction}

      0x14A0 ->
        {:ok, :client_information}

      0x142A ->
        {:ok, :open_gift}

      _ ->
        {:error, :unknown_packet_id, "0x" <> Integer.to_string(packet_id, 16)}
    end
  end

  defp parser(data, socket, transport, bucket) do
    <<sz::binary-size(2), id::binary-size(2), rest::binary>> = data
    _size = :binary.decode_unsigned(sz, :little)
    packet_id = :binary.decode_unsigned(id, :little)
    case packet_type(packet_id) do
      {:ok, packet_type} ->
        case packet_type do
          :login ->
            [username: username, password_hash: password_hash] =
              Fauxpets.Protocol.Client.Login.handle_packet(rest)

            login_response = Fauxpets.User.attempt_login(username, password_hash)

            Fauxpets.Protocol.Server.LoginResponse.send_packet(socket, transport,
              login_response: login_response
            )

            case login_response do
              {:ok, user} ->
                Fauxpets.ProtocolBucket.login(bucket, user)

              {:error, _} ->
                :ok = transport.close(socket)
            end

          :open_gift ->
            Fauxpets.Protocol.Server.FortuneCookieResult.send_packet(socket, transport, type: :green, gold: 0, pink: 0, green: 100, item: 0)

          :client_information ->
            [resp: resp] = Fauxpets.Protocol.Client.ClientInfo.handle_packet(rest)

            case resp do
              {:ok, :client_login_ok} ->
                if Fauxpets.ProtocolBucket.is_logged_in(bucket) do
                  Logger.info("Sending user data!")
                  user = Fauxpets.ProtocolBucket.get_user(bucket)
                  Fauxpets.Protocol.Server.MyUserInfo.send_packet(socket, transport, user: user)
                  Fauxpets.Protocol.Server.BoxList.send_packet(socket, transport, box_list: [%{name: "Test Box"}])
                  Fauxpets.Protocol.Server.InventoryListStart.send_packet(socket, transport, [inv_no: 0])
                  Fauxpets.Protocol.Server.InventoryList.send_packet(socket, transport, [len: 1, inv_no: 0])
                  Fauxpets.Protocol.Server.InventoryListEnd.send_packet(socket, transport, [])
                  Fauxpets.Protocol.Server.PiggyBank.send_packet(socket, transport,
                    gold: user.wallet.gold,
                    pink: user.wallet.pink,
                    green: user.wallet.green,
                    prize: user.wallet.prize
                  )
                  Fauxpets.Protocol.Server.PetList.send_packet(socket, transport, [user_id: user.id, pet_list: [%{id: 1, name: "Dipshit", portrait_no: 1, index: 1}]])
                  Fauxpets.Protocol.Server.LoadEnd.send_packet(socket, transport, [])
                else
                  Logger.error("Tried to call client login procession w/o login")
                end

              _ ->
                nil
            end

          :client_interaction ->
            <<id::size(2)-unit(8)-unsigned-integer-little, rest::binary>> = rest
            id_str = Integer.to_string(id, 16)

            cond do
              id >= 0x6D60 && id <= 0x6D6B ->
                Logger.info("Loading phase #{id-0x6D60}")
              id >= 0x6F54 && id <= 0x6F5F ->
                Logger.warning("Probably don't have a petlist?")
              true ->
                Logger.info("Received client interaction (id: 0x#{id_str} #{inspect(rest, binaries: :as_binaries)})")
            end

          :client_disconnect ->
            Fauxpets.Protocol.Client.Disconnect.handle_packet(rest)

            :ok = transport.close(socket)

          _ ->
            Logger.error(
              "got unknown packet type!!!! #{packet_type} - #{inspect(rest, binaries: :as_binaries)}"
            )

            :ok = transport.close(socket)
        end
      {:error, :unknown_packet_id, id} ->
        Logger.error("Couldn't respond to packet #{id}... (#{inspect(rest, binaries: :as_binaries)})")
    end
  end
end
