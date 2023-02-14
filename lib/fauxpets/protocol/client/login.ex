defmodule Fauxpets.Protocol.Client.Login do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def parse_packet(data) do
    {:ok, username, rest} = Fauxpets.Protocol.Util.pop_string(data)
    {:ok, password_hash, _rest} = Fauxpets.Protocol.Util.pop_string(rest)

    [username: username, password_hash: password_hash]
  end

  @impl true
  def handle_packet(socket, transport, conn_state, [username: username, password_hash: password_hash]) do
    login_response = Fauxpets.User.attempt_login(username, password_hash)

    Fauxpets.Protocol.Server.LoginResponse.send_packet(socket, transport,
      login_response: login_response
    )

    case login_response do
      {:ok, user} ->
        Fauxpets.ConnectionState.login(conn_state, user)
        send_login_data(socket, transport, conn_state)

      {:error, _} ->
        :ok = transport.close(socket)
    end
  end

  defp send_login_data(socket, transport, conn_state) do
    if Fauxpets.ConnectionState.is_logged_in(conn_state) do
      Logger.info("Sending user data!")

      user = Fauxpets.ConnectionState.get_user(conn_state)

      Fauxpets.Protocol.Server.MyUserInfo.send_packet(socket, transport, user: user)

      Fauxpets.Protocol.Server.Level.send_packet(socket, transport, level: 6, exp: 0)

      Fauxpets.Protocol.Server.FriendList.send_packet(socket, transport,
        user: user,
        friend_list: [[id: 0x69, type: :admin], [id: 0x79, type: :admin]]
      )

      Fauxpets.Protocol.Server.SentRingList.send_packet(socket, transport, sent_ring_list: [])

      Fauxpets.Protocol.Server.BlockUserList.send_packet(socket, transport, block_list: [])

      Fauxpets.Protocol.Server.BoxList.send_packet(socket, transport, box_list: user.boxes)

      Fauxpets.Protocol.Server.PiggyBank.send_packet(socket, transport,
        gold: user.wallet.gold,
        pink: user.wallet.pink,
        green: user.wallet.green,
        prize: user.wallet.prize
      )

      Fauxpets.Protocol.Server.PetList.send_packet(socket, transport,
        user_id: user.id,
        pet_list: [%{id: 10, name: "Dipshit", portrait_no: 2, index: 1}]
      )

      Fauxpets.Protocol.Server.ProfessionInfo.send_packet(socket, transport, [])


      # Fauxpets.Protocol.Server.AdminList.send_packet(socket, transport, admins: [user])

      Fauxpets.Protocol.Server.GV.LoginClient.send_packet(socket, transport, [])
      Fauxpets.Protocol.Server.GV.DesktopInfo.send_packet(socket, transport, [])
      # Fauxpets.Protocol.Server.GV.Join.send_packet(socket, transport, [])
      Fauxpets.Protocol.Server.LoadSettingItem.send_packet(socket, transport, type: :desktop)
      # Fauxpets.Protocol.Server.GV.Member.send_packet(socket, transport, member_list: [])

      Fauxpets.Protocol.Server.LoadPetEnterData.send_packet(socket, transport, [])

      Fauxpets.Protocol.Server.LoadEnd.send_packet(socket, transport, [])

      # Fauxpets.Protocol.Server.PetPortrait.send_packet(socket, transport, [pet_id: 1, revision: 1])

      # Fauxpets.Protocol.Server.EnterPet.send_packet(socket, transport, [])

      # Fauxpets.Protocol.Server.ChangePetSkin.send_packet(socket, transport, [])
    else
      Logger.error("Tried to call client login procession w/o login")
    end
  end
end
