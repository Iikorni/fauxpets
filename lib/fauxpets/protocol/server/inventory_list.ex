defmodule Fauxpets.Protocol.Server.InventoryList do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, [len: len, inv_no: inv_no]) do
    Logger.info("InventoryList send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BCC,
      Fauxpets.Protocol.Util.encode_short(inv_no) <> # Inventory Number
      Fauxpets.Protocol.Util.encode_short(len) <> # Number of Items

      Fauxpets.Protocol.Util.encode_short(0) <> # SLOT NUMBER (0 indexed?)
      Fauxpets.Protocol.Util.encode_byte(8) <>

      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_string("ttt") <>
      Fauxpets.Protocol.Util.encode_int(0) <>
      Fauxpets.Protocol.Util.encode_int(1) <>
      Fauxpets.Protocol.Util.encode_byte(1) <>
      Fauxpets.Protocol.Util.encode_byte(1)))
# FOR SLOT 3 (actual items)
#       Fauxpets.Protocol.Util.encode_int(-1) <>
#       Fauxpets.Protocol.Util.encode_byte(0) <> # Used?
#       Fauxpets.Protocol.Util.encode_int(5) <> # QTY
#       Fauxpets.Protocol.Util.encode_short(5) <>
#       Fauxpets.Protocol.Util.encode_bool(false) <> # New Item?
#       Fauxpets.Protocol.Util.encode_int(5) <> # Item ID
#       Fauxpets.Protocol.Util.encode_short(2) <> # Reaction
#       Fauxpets.Protocol.Util.encode_int(0) <> # Special Meter Stuff???
#       Fauxpets.Protocol.Util.encode_short(1) <>
#       Fauxpets.Protocol.Util.encode_byte(0x15) <> # Good Type
# # g_Define.GOODS_TYPE_ATTACH                                     = 1
# # g_Define.GOODS_TYPE_WRAP                                       = 2
# # g_Define.GOODS_TYPE_SETTING_ITEM                               = 3
# # g_Define.GOODS_TYPE_FUNCTION                                   = 4
# # g_Define.GOODS_TYPE_DIRECT_USE                                 = 5
# # g_Define.GOODS_TYPE_GAME                                       = 6
# # g_Define.GOODS_TYPE_SOUND                                      = 7
# # g_Define.GOODS_TYPE_FRIENDSRING                                = 8
# # g_Define.GOODS_TYPE_BABYPET_BASKET                             = 9
# # g_Define.GOODS_TYPE_RECIPE_BOOK                                = 10
# # g_Define.GOODS_TYPE_FISHING_PLACE                              = 11
# # g_Define.GOODS_TYPE_SLOT_ITEM                                  = 12
# # g_Define.GOODS_TYPE_TREASURECHEST                              = 13
# # g_Define.GOODS_TYPE_DESK_SHOP                                  = 14
# # g_Define.GOODS_TYPE_TELEPORT                                   = 15
# # g_Define.GOODS_TYPE_GROWING_FRUIT                              = 50
#       Fauxpets.Protocol.Util.encode_byte(1) <> # What Type
# # g_Define.WHAT_TYPE_NONE                                        = 0
# # g_Define.WHAT_TYPE_FOOD                                        = 1
# # g_Define.WHAT_TYPE_DRINK                                       = 2
# # g_Define.WHAT_TYPE_TOY                                         = 3
# # g_Define.WHAT_TYPE_BATH                                        = 4
# # g_Define.WHAT_TYPE_BATH_TOOL                                   = 5
# # g_Define.WHAT_TYPE_FORTUNE_COOKIE                              = 6
# # g_Define.WHAT_TYPE_SUBS_REWARD                                 = 7
# # g_Define.WHAT_TYPE_DECORATION                                  = 8
# # g_Define.WHAT_TYPE_HOUSE                                       = 9
# # g_Define.WHAT_TYPE_COUNTABLE_USEITEM                           = 10
# # g_Define.WHAT_TYPE_CRAFTING_TOOL                               = 11
# # g_Define.WHAT_TYPE_POST                                        = 12
#       Fauxpets.Protocol.Util.encode_int(1337) <> # GOLD
#       Fauxpets.Protocol.Util.encode_int(6969) <> # PINK
#       Fauxpets.Protocol.Util.encode_int(4200) <> # GREEN
#       Fauxpets.Protocol.Util.encode_int(8008) <> # ITEM
#       Fauxpets.Protocol.Util.encode_short(0) <>
#       Fauxpets.Protocol.Util.encode_bool(false) <>
#       Fauxpets.Protocol.Util.encode_string("test") <> # Breed Field? Weird
#       Fauxpets.Protocol.Util.encode_float(10.0) <>
#       Fauxpets.Protocol.Util.encode_float(9.0) <>
#       Fauxpets.Protocol.Util.encode_float(8.0) <>
#       Fauxpets.Protocol.Util.encode_float(7.0) <>
#       Fauxpets.Protocol.Util.encode_float(6.0) <>
#       Fauxpets.Protocol.Util.encode_string("test2") <>
#       Fauxpets.Protocol.Util.encode_string("test3") <>
#       Fauxpets.Protocol.Util.encode_bool(false) <> # Customizable?
#       Fauxpets.Protocol.Util.encode_int(0) <>
#       Fauxpets.Protocol.Util.encode_int(3) <> # Reverse bitmask for gift/stall icons? 0x1 masks out gift, 0x2 masks out stall
#       Fauxpets.Protocol.Util.encode_byte(39) <> # Use Level
#       Fauxpets.Protocol.Util.encode_string("") <> # Maker
#       Fauxpets.Protocol.Util.encode_int(5) <>
#       Fauxpets.Protocol.Util.encode_int(5) <> # Physical
#       Fauxpets.Protocol.Util.encode_int(6) <> # Energy
#       Fauxpets.Protocol.Util.encode_int(7) <> # Karma
#       Fauxpets.Protocol.Util.encode_int(-1) <> # Buff Time?
#       Fauxpets.Protocol.Util.encode_byte(0) <> # Quest?
#       Fauxpets.Protocol.Util.encode_float(1.0) <>
#       Fauxpets.Protocol.Util.encode_float(2.0) <>
#       Fauxpets.Protocol.Util.encode_float(3.0)))
      # FOR SLOT TYPE 1 (IKU)
      #Fauxpets.Protocol.Util.encode_int(1) <>
      #Fauxpets.Protocol.Util.encode_int(10809) <> # ICON ID
      #Fauxpets.Protocol.Util.encode_int(10809) <>
      #Fauxpets.Protocol.Util.encode_string("What")))
      # FOR SLOT TYPE 5
      #Fauxpets.Protocol.Util.encode_int(0) <>
      #Fauxpets.Protocol.Util.encode_int(0) <>
      #Fauxpets.Protocol.Util.encode_int(40002) <> # THIS SEEMS TO BE THE ITEM ID??????
      #Fauxpets.Protocol.Util.encode_int(1) <>
      #Fauxpets.Protocol.Util.encode_int(1) <>
      #Fauxpets.Protocol.Util.encode_string("What")))
  end

  defp append_slot_to_packet(packet, index, [slot | tail]) do

  end
end
