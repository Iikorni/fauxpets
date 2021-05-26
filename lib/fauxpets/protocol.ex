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
    case transport.recv(socket, 0, 60000 * 5) do
      {:ok, data} ->
        parser(data, socket, transport, bucket)
        loop(socket, transport, bucket)

      _ ->
        Logger.info("closing client connection...")
        :ok = transport.close(socket)
    end
  end

  defp send_login_data(socket, transport, bucket) do
    if Fauxpets.ProtocolBucket.is_logged_in(bucket) do
      Logger.info("Sending user data!")

      user = Fauxpets.ProtocolBucket.get_user(bucket)
      Fauxpets.Protocol.Server.MyUserInfo.send_packet(socket, transport, user: user)

      Fauxpets.Protocol.Server.Level.send_packet(socket, transport, level: 10, exp: 100)

      Fauxpets.Protocol.Server.FriendList.send_packet(socket, transport,
        user: user,
        friend_list: [[id: 0x69, type: :admin], [id: 0x79, type: :admin]]
      )

      Fauxpets.Protocol.Server.SentRingList.send_packet(socket, transport, sent_ring_list: [2])

      Fauxpets.Protocol.Server.BlockUserList.send_packet(socket, transport, block_list: [])

      Fauxpets.Protocol.Server.BoxList.send_packet(socket, transport, box_list: user.boxes)

      Fauxpets.Protocol.Server.InventoryList.send_packet(socket, transport,
        inv_no: 0,
        box: Enum.at(user.boxes, 0)
      )

      Fauxpets.Protocol.Server.PiggyBank.send_packet(socket, transport,
        gold: user.wallet.gold,
        pink: user.wallet.pink,
        green: user.wallet.green,
        prize: user.wallet.prize
      )

      Fauxpets.Protocol.Server.PetList.send_packet(socket, transport,
        user_id: user.id,
        pet_list: [%{id: 1, name: "Dipshit", portrait_no: 1, index: 1}]
      )

      Fauxpets.Protocol.Server.GV.LoginClient.send_packet(socket, transport, [])
      Fauxpets.Protocol.Server.GV.DesktopInfo.send_packet(socket, transport, [])
      Fauxpets.Protocol.Server.SettingItem.send_packet(socket, transport, type: :desktop)
      # Fauxpets.Protocol.Server.GV.Member.send_packet(socket, transport, member_list: [])

      Fauxpets.Protocol.Server.LoadEnd.send_packet(socket, transport, [])
    else
      Logger.error("Tried to call client login procession w/o login")
    end
  end

  defp parser(data, socket, transport, bucket) do
    Logger.debug("Got packet: #{inspect(data)}")

    <<packet_size::size(2)-unit(8)-unsigned-integer-little,
      packet_id::size(2)-unit(8)-unsigned-integer-little, rest::binary>> = data

    [rest, tail] =
      if byte_size(rest) + 2 != packet_size do
        chop_size = packet_size - 2
        <<head::binary-size(chop_size), tail::binary>> = rest
        [head, tail]
      else
        [rest, nil]
      end

    case Fauxpets.Protocol.Client.packet_type(packet_id) do
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
                send_login_data(socket, transport, bucket)

              {:error, _} ->
                :ok = transport.close(socket)
            end

          :open_gift ->
            [inv_no: inv_no, slot_index: slot_index] =
              Fauxpets.Protocol.Client.OpenGift.handle_packet(rest)

            Logger.info("Got gift open! (Inventory #{inv_no}, Slot #{slot_index})")

            Fauxpets.Protocol.Server.OpenGiftItem.send_packet(socket, transport,
              inv_no: inv_no,
              slot_index: slot_index
            )

          :client_information ->
            [resp: resp] = Fauxpets.Protocol.Client.ClientInfo.handle_packet(rest)

            case resp do
              {:ok, type} ->
                Logger.info("Client wrote a log entry: '#{inspect(type)}'")

              {:error, :unknown_code, data} ->
                Logger.error(
                  "Unknown client information code - data is '#{
                    inspect(data, binaries: :as_binaries)
                  }'"
                )
            end

          :client_log_gui ->
            [resp: [type: type, data: data]] = Fauxpets.Protocol.Client.LogGUI.handle_packet(rest)

            case type do
              {:ok, evt} ->
                Logger.info(
                  "Client logged GUI event '#{inspect(evt)}' #{
                    if data != <<>>, do: inspect(data, binaries: :as_binaries)
                  }"
                )

              {:error, [unknown_type: evt]} ->
                Logger.info(
                  "Client logged unknown GUI event! '#{inspect(evt)}' #{
                    if data != <<>>, do: inspect(data, binaries: :as_binaries)
                  }"
                )
            end

          :client_disconnect ->
            Fauxpets.Protocol.Client.Disconnect.handle_packet(rest)

            :ok = transport.close(socket)

          :client_request_user ->
            [resp: [name: name]] = Fauxpets.Protocol.Client.RequestUser.handle_packet(rest)

            Logger.info("Client wants information for the user '#{name}'")

          :create_pet ->
            Fauxpets.Protocol.Client.CreatePet.handle_packet(rest)

          :lang_no ->
            [resp: {:ok, lang}] = Fauxpets.Protocol.Client.LangNo.handle_packet(rest)

            Logger.info("Client reports language '#{Fauxpets.Protocol.Client.LangNo.lang_to_str(lang)}'")

          _ ->
            Logger.error(
              "got unknown packet type!!!! #{packet_type} - #{
                inspect(rest, binaries: :as_binaries)
              }"
            )

            :ok = transport.close(socket)
        end

      {:error, :unknown_packet_id, id} ->
        Logger.error(
          "Couldn't respond to packet #{id}... (#{inspect(rest, binaries: :as_binaries)})"
        )
    end

    if tail != nil do
      total_len = byte_size(data)
      expected_len = packet_size + 2
      Logger.debug("Length #{total_len} was not #{expected_len}! Resending...")
      parser(tail, socket, transport, bucket)
    end
  end
end
