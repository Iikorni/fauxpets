defmodule Fauxpets.Protocol.Client.LogGUI do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  def get_type_for_id(id) do
    case id do
      0 ->
        {:ok, :piano}

      1 ->
        {:ok, :map}

      2 ->
        {:ok, :giftbox}

      3 ->
        {:ok, :deliverybox}

      4 ->
        {:ok, :piggybank}

      5 ->
        {:ok, :texturecontrol}

      6 ->
        {:ok, :changepet}

      100 ->
        {:ok, :pet_namepanel}

      101 ->
        {:ok, :pet_traveljournal}

      102 ->
        {:ok, :pet_goaway}

      103 ->
        {:ok, :pet_petsblog}

      104 ->
        {:ok, :pet_ownersblog}

      105 ->
        {:ok, :pet_ownersprofile}

      106 ->
        {:ok, :pet_ownerssendiku}

      107 ->
        {:ok, :pet_ownersim}

      108 ->
        {:ok, :pet_status}

      109 ->
        {:ok, :pet_senddeliverygift}

      110 ->
        {:ok, :pet_callmypet}

      111 ->
        {:ok, :pet_blockuser}

      112 ->
        {:ok, :pet_wanderingcontrol}

      113 ->
        {:ok, :pet_deletepet}

      200 ->
        {:ok, :main_viewuserprofile}

      201 ->
        {:ok, :main_viewpetprofile}

      202 ->
        {:ok, :main_viewfriend}

      203 ->
        {:ok, :main_viewmsgpalette}

      204 ->
        {:ok, :main_viewgame}

      205 ->
        {:ok, :main_viewwhatsnew}

      206 ->
        {:ok, :main_viewinventory}

      207 ->
        {:ok, :main_viewstore}

      208 ->
        {:ok, :main_viewwww}

      209 ->
        {:ok, :main_viewwebhelp}

      210 ->
        {:ok, :main_help}

      211 ->
        {:ok, :main_close}

      212 ->
        {:ok, :main_mini}

      213 ->
        {:ok, :main_exit}

      214 ->
        {:ok, :main_option}

      215 ->
        {:ok, :main_petportraitslot1}

      216 ->
        {:ok, :main_petportraitslot2}

      217 ->
        {:ok, :main_petportraitslot3}

      218 ->
        {:ok, :main_petportraitslot4}

      219 ->
        {:ok, :main_viewemail}

      220 ->
        {:ok, :main_viewbaduser}

      300 ->
        {:ok, :cmd_callmypet}

      301 ->
        {:ok, :cmd_makeplaypen}

      302 ->
        {:ok, :cmd_removeplaypen}

      303 ->
        {:ok, :cmd_option}

      400 ->
        {:ok, :frd_im}

      401 ->
        {:ok, :frd_sendpet}

      402 ->
        {:ok, :frd_sendmessage}

      403 ->
        {:ok, :frd_showfriend}

      404 ->
        {:ok, :frd_toggleview}

      405 ->
        {:ok, :frd_showprofile}

      406 ->
        {:ok, :frd_showblog}

      407 ->
        {:ok, :frd_privous}

      408 ->
        {:ok, :frd_next}

      409 ->
        {:ok, :frd_help}

      410 ->
        {:ok, :frd_addasfriend}

      411 ->
        {:ok, :frd_addtoblocklist}

      412 ->
        {:ok, :frd_showblocklist}

      500 ->
        {:ok, :plt_createmsg}

      501 ->
        {:ok, :plt_addwordorpic}

      502 ->
        {:ok, :plt_inbox}

      503 ->
        {:ok, :plt_outbox}

      504 ->
        {:ok, :plt_favorite}

      505 ->
        {:ok, :plt_privous}

      506 ->
        {:ok, :plt_next}

      507 ->
        {:ok, :plt_search}

      508 ->
        {:ok, :plt_help}

      509 ->
        {:ok, :plt_showblog}

      510 ->
        {:ok, :plt_im}

      511 ->
        {:ok, :plt_addasfriend}

      512 ->
        {:ok, :plt_showprofile}

      513 ->
        {:ok, :plt_addtoblocklist}

      600 ->
        {:ok, :mbox_read}

      601 ->
        {:ok, :mbox_delete}

      602 ->
        {:ok, :mbox_palette}

      603 ->
        {:ok, :mbox_inbox}

      604 ->
        {:ok, :mbox_outbox}

      605 ->
        {:ok, :mbox_favorite}

      606 ->
        {:ok, :mbox_help}

      607 ->
        {:ok, :mbox_addfavorite}

      608 ->
        {:ok, :mbox_deleteall}

      700 ->
        {:ok, :mat_sendto}

      701 ->
        {:ok, :mat_send}

      702 ->
        {:ok, :mat_deleteiku}

      703 ->
        {:ok, :mat_cancel}

      704 ->
        {:ok, :mat_help}

      705 ->
        {:ok, :mat_viewuserprofile}

      800 ->
        {:ok, :inv_recycle}

      801 ->
        {:ok, :inv_help}

      802 ->
        {:ok, :inv_viewpetinventory}

      803 ->
        {:ok, :inv_newinventory}

      804 ->
        {:ok, :inv_mystore}

      805 ->
        {:ok, :inv_sendgift}

      900 ->
        {:ok, :map_travelhistory}

      901 ->
        {:ok, :map_counttravel}

      902 ->
        {:ok, :map_countusers}

      903 ->
        {:ok, :map_help}

      1000 ->
        {:ok, :txt_viewcontrol}

      1001 ->
        {:ok, :txt_morecontrol}

      1002 ->
        {:ok, :txt_prevouscontrol}

      1003 ->
        {:ok, :txt_help}

      1100 ->
        {:ok, :changepet_left}

      1101 ->
        {:ok, :changepet_right}

      1102 ->
        {:ok, :changepet_help}

      1200 ->
        {:ok, :wrapgift_help}

      1201 ->
        {:ok, :wrapgift_goshop}

      1202 ->
        {:ok, :wrapgift_ok}

      1203 ->
        {:ok, :wrapgift_cancel}

      1300 ->
        {:ok, :gotgift_help}

      1301 ->
        {:ok, :gotgift_ok}

      1302 ->
        {:ok, :gotgift_cancel}

      1400 ->
        {:ok, :addpic_help}

      1401 ->
        {:ok, :addpic_browse}

      1402 ->
        {:ok, :addpic_language}

      1500 ->
        {:ok, :option_help}

      1501 ->
        {:ok, :option_hideobj}

      1502 ->
        {:ok, :option_mute}

      1503 ->
        {:ok, :option_playpen}

      1504 ->
        {:ok, :option_ok}

      1505 ->
        {:ok, :option_language}

      1506 ->
        {:ok, :option_petnum}

      1507 ->
        {:ok, :option_visitmode}

      1508 ->
        {:ok, :option_sendtobg}

      1509 ->
        {:ok, :option_staymode}

      1510 ->
        {:ok, :option_aroundland}

      1511 ->
        {:ok, :option_shownameplate}

      1512 ->
        {:ok, :option_windowmode}

      1513 ->
        {:ok, :option_close}

      1600 ->
        {:ok, :petinv_close}

      1601 ->
        {:ok, :petinv_help}

      1602 ->
        {:ok, :petinv_detach}

      1603 ->
        {:ok, :petinv_inventory}

      1700 ->
        {:ok, :add_help}

      1701 ->
        {:ok, :add_privous}

      1800 ->
        {:ok, :mystore_help}

      1801 ->
        {:ok, :mystore_status}

      1802 ->
        {:ok, :mystroe_sell}

      1900 ->
        {:ok, :petstatus_help}

      2000 ->
        {:ok, :solid_help}

      2001 ->
        {:ok, :solid_detach}

      2100 ->
        {:ok, :usercreateitem_help}

      2200 ->
        {:ok, :userattach_picture}

      2201 ->
        {:ok, :userattach_extract}

      2202 ->
        {:ok, :userattach_browse}

      2203 ->
        {:ok, :userattach_upload}

      2204 ->
        {:ok, :userattach_camera}

      2300 ->
        {:ok, :usernameplate_extract}

      2301 ->
        {:ok, :usernameplate_browse}

      2302 ->
        {:ok, :usernameplate_upload}

      2400 ->
        {:ok, :breed_converting_help}

      2401 ->
        {:ok, :breed_converting_close}

      2402 ->
        {:ok, :breed_converting_mini}

      2500 ->
        {:ok, :quantity_close}

      2600 ->
        {:ok, :quest_dlg}

      2601 ->
        {:ok, :quest_accept}

      2602 ->
        {:ok, :quest_complete}

      2700 ->
        {:ok, :petcreation_rotatepet}

      2701 ->
        {:ok, :petcreation_petgroup}

      2702 ->
        {:ok, :petcreation_selectpet}

      2703 ->
        {:ok, :petcreation_cat}

      2704 ->
        {:ok, :petcreation_dog}

      2705 ->
        {:ok, :petcreation_panda}

      2706 ->
        {:ok, :petcreation_horse}

      2707 ->
        {:ok, :petcreation_monkey}

      2708 ->
        {:ok, :petcreation_petname}

      2709 ->
        {:ok, :petcreation_male}

      2710 ->
        {:ok, :petcreation_female}

      2711 ->
        {:ok, :petcreation_changepattern}

      2712 ->
        {:ok, :petcreation_changenummetaskin}

      2713 ->
        {:ok, :petcreation_changecolor}

      2714 ->
        {:ok, :petcreation_changebellycolor}

      2715 ->
        {:ok, :petcreation_changepatterncolor}

      2716 ->
        {:ok, :petcreation_changeeyecolor}

      2717 ->
        {:ok, :petcreation_enterdialog}

      2718 ->
        {:ok, :petcreation_createpet}

      2750 ->
        {:ok, :petcreation_createpetresult}

      27500 ->
        {:ok, :loadinginit}

      28000 ->
        {:ok, :loading}

      28500 ->
        {:ok, :loadingdone}

      _ ->
        {:error, [unknown_type: id]}
    end
  end

  @impl true
  def parse_packet(data) do
    <<id::size(2)-unit(8)-unsigned-integer-little, rest::binary>> = data
    [type: get_type_for_id(id), data: rest]
  end

  @impl true
  def handle_packet(_socket, _transport, _conn_state, [type: type, data: data]) do
    case type do
      {:ok, evt} ->
        Logger.info(
          "Client logged GUI event '#{inspect(evt)}' #{if data != <<>>, do: inspect(data, binaries: :as_binaries)}"
        )

      {:error, [unknown_type: evt]} ->
        Logger.info(
          "Client logged unknown GUI event! '#{inspect(evt)}' #{if data != <<>>, do: inspect(data, binaries: :as_binaries)}"
        )
    end
  end
end
