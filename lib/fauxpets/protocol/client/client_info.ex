defmodule Fauxpets.Protocol.Client.ClientInfo do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  @impl true
  def parse_packet(data) do
    <<id::size(2)-unit(8)-unsigned-integer-little, _rest::binary>> = data

    case id do
      0 ->
        [resp: {:ok, :client_login}]

      1 ->
        [resp: {:ok, :client_logout}]

      2 ->
        [resp: {:ok, :client_loading_start}]

      3 ->
        [resp: {:ok, :client_loading_end}]

      4 ->
        [resp: {:ok, :make_pet}]

      5 ->
        [resp: {:ok, :drop_item}]

      6 ->
        [resp: {:ok, :enter_pet}]

      7 ->
        [resp: {:ok, :attach_equip_item}]

      8 ->
        [resp: {:ok, :sell_my_store}]

      9 ->
        [resp: {:ok, :recycle_item}]

      10 ->
        [resp: {:ok, :use_item_maker}]

      11 ->
        [resp: {:ok, :make_box}]

      12 ->
        [resp: {:ok, :buy_shell_page}]

      13 ->
        [resp: {:ok, :search_friend}]

      14 ->
        [resp: {:ok, :send_pet}]

      15 ->
        [resp: {:ok, :show_friend_profile}]

      16 ->
        [resp: {:ok, :block_friend}]

      17 ->
        [resp: {:ok, :move_friend_land}]

      18 ->
        [resp: {:ok, :send_friendship_ring}]

      19 ->
        [resp: {:ok, :invite_pet}]

      20 ->
        [resp: {:ok, :search_iku}]

      21 ->
        [resp: {:ok, :send_iku}]

      22 ->
        [resp: {:ok, :read_iku}]

      23 ->
        [resp: {:ok, :send_present}]

      24 ->
        [resp: {:ok, :receive_present_web}]

      25 ->
        [resp: {:ok, :send_present_web}]

      26 ->
        [resp: {:ok, :go_chat}]

      27 ->
        [resp: {:ok, :forum_web}]

      28 ->
        [resp: {:ok, :community_web}]

      29 ->
        [resp: {:ok, :my_blog_web}]

      30 ->
        [resp: {:ok, :game_ranking_web}]

      31 ->
        [resp: {:ok, :shopping}]

      32 ->
        [resp: {:ok, :move_land}]

      33 ->
        [resp: {:ok, :land_book}]

      34 ->
        [resp: {:ok, :land_permission}]

      35 ->
        [resp: {:ok, :land_sale}]

      36 ->
        [resp: {:ok, :land_buy}]

      37 ->
        [resp: {:ok, :land_buy_to_user_land}]

      38 ->
        [resp: {:ok, :return_decoration}]

      39 ->
        [resp: {:ok, :lock_decoration}]

      40 ->
        [resp: {:ok, :change_land_name}]

      41 ->
        [resp: {:ok, :quest_accept}]

      42 ->
        [resp: {:ok, :quest_complete}]

      43 ->
        [resp: {:ok, :learn_recipe}]

      44 ->
        [resp: {:ok, :crafting_make_item}]

      45 ->
        [resp: {:ok, :battle_monster}]

      46 ->
        [resp: {:ok, :set_option}]

      47 ->
        [resp: {:ok, :notice_web}]

      48 ->
        [resp: {:ok, :email_web}]

      49 ->
        [resp: {:ok, :report_user_web}]

      50 ->
        [resp: {:ok, :faq_web}]

      51 ->
        [resp: {:ok, :game_guide_web}]

      52 ->
        [resp: {:ok, :training_guide_web}]

      53 ->
        [resp: {:ok, :leveling_guide_web}]

      54 ->
        [resp: {:ok, :item_maker_web}]

      55 ->
        [resp: {:ok, :change_pet_slot}]

      56 ->
        [resp: {:ok, :tag_item}]

      57 ->
        [resp: {:ok, :_3d_shop_register}]

      58 ->
        [resp: {:ok, :_3d_shop_buy}]

      59 ->
        [resp: {:ok, :buy_subscription}]

      60 ->
        [resp: {:ok, :add_friend}]

      61 ->
        [resp: {:ok, :user_kick}]

      62 ->
        [resp: {:ok, :generator_fishing}]

      63 ->
        [resp: {:ok, :pet_action}]

      64 ->
        [resp: {:ok, :chat_filter}]

      65 ->
        [resp: {:ok, :chatting}]

      66 ->
        [resp: {:ok, :play_mini_game}]

      67 ->
        [resp: {:ok, :play_sound}]

      68 ->
        [resp: {:ok, :enter_house}]

      69 ->
        [resp: {:ok, :change_wallpaper}]

      70 ->
        [resp: {:ok, :change_skybox}]

      71 ->
        [resp: {:ok, :item_drop}]

      72 ->
        [resp: {:ok, :change_camera_mode}]

      73 ->
        [resp: {:ok, :camera_control}]

      74 ->
        [resp: {:ok, :jumpstone}]

      75 ->
        [resp: {:ok, :call_pet}]

      76 ->
        [resp: {:ok, :init_craft_skill}]

      77 ->
        [resp: {:ok, :cancel_friendship_ring}]

      78 ->
        [resp: {:ok, :send_user_pet}]

      79 ->
        [resp: {:ok, :show_tag}]

      80 ->
        [resp: {:ok, :default_land}]

      81 ->
        [resp: {:ok, :set_return_land}]

      82 ->
        [resp: {:ok, :breed_change}]

      83 ->
        [resp: {:ok, :user_blog}]

      84 ->
        [resp: {:ok, :whisper}]

      85 ->
        [resp: {:ok, :pet_adoption}]

      86 ->
        [resp: {:ok, :petting}]

      87 ->
        [resp: {:ok, :go_my_land}]

      88 ->
        [resp: {:ok, :leave_my_land}]

      _ ->
        [resp: {:error, :unknown_code, data}]
    end
  end


  @impl true
  def handle_packet(_socket, _transport, _conn_state, [resp: resp]) do
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
  end
end
