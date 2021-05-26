defmodule Fauxpets.Protocol.Server.InventoryList do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  defp append_stacks(packet, []) do
    packet
  end

  defp append_stacks(packet, [stack | tail]) do
    packet =
      packet <>
      Fauxpets.Protocol.Util.encode_short(stack.slot_index) <> # SLOT NUMBER (0 indexed?)
      Fauxpets.Protocol.Util.encode_byte(3) <>

      Fauxpets.Protocol.Util.encode_int(0) <>
      Fauxpets.Protocol.Util.encode_byte(0) <> # Used?
      Fauxpets.Protocol.Util.encode_int(stack.quantity) <> # QTY
      Fauxpets.Protocol.Util.encode_short(0) <>
      Fauxpets.Protocol.Util.encode_bool(false) <> # New Item?
      Fauxpets.Protocol.Util.encode_int(stack.item.id) <> # Item ID
      Fauxpets.Protocol.Util.encode_short(Fauxpets.Item.reaction_to_short(stack.item.reaction)) <> # Reaction
      Fauxpets.Protocol.Util.encode_int(0) <> # Meter Int?
      Fauxpets.Protocol.Util.encode_short(0) <>  # MOVEMENT
      # g_Define.MOVEMENT_OBJ_FOOD                                     = 0
# g_Define.MOVEMENT_OBJ_BALL                                     = 1
# g_Define.MOVEMENT_OBJ_FLYING_BUG                               = 2
# g_Define.MOVEMENT_OBJ_BALLOON                                  = 4
# g_Define.MOVEMENT_OBJ_GETHER_BUTTERFLY                         = 5
# g_Define.MOVEMENT_OBJ_GETHER_MOVEOBJ                           = 6
# g_Define.MOVEMENT_OBJ_GETHER_SEAGULL                           = 7
# g_Define.MOVEMENT_OBJ_MONSTER                                  = 8
# g_Define.MOVEMENT_OBJ_HEADING                                  = 13
# g_Define.MOVEMENT_OBJ_GOURL                                    = 14
# g_Define.MOVEMENT_OBJ_STAND_UP                                 = 100
# g_Define.MOVEMENT_OBJ_STAND_DOWN                               = 101
# g_Define.MOVEMENT_OBJ_ITEM_ANI                                 = 300
# g_Define.MOVEMENT_OBJ_ITEM_MISTLETOE                           = 301
# g_Define.MOVEMENT_OBJ_MUSHROOM                                 = 302
# g_Define.MOVEMENT_OBJ_MOVE_ANI                                 = 303
# g_Define.MOVEMENT_OBJ_RIDE                                     = 304
# g_Define.MOVEMENT_OBJ_MICROPET                                 = 305
# g_Define.MOVEMENT_OBJ_CANIVAL                                  = 306
# g_Define.MOVEMENT_OBJ_MANUAL                                   = 307
# g_Define.MOVEMENT_OBJ_HOUSE_ANI                                = 308
# g_Define.MOVEMENT_OBJ_FOOD_ANI                                 = 309
# g_Define.MOVEMENT_OBJ_HUNTED_HOUSE                             = 310
# g_Define.MOVEMENT_OBJ_REMOVEMOLDING_HOUSE                      = 311
# g_Define.MOVEMENT_OBJ_JUKEBOX                                  = 312
# g_Define.MOVEMENT_OBJ_POGOSTICK                                = 313
# g_Define.MOVEMENT_OBJ_SIMPLICITY                               = 314
# g_Define.MOVEMENT_OBJ_TOUGHTRUNKTREE                           = 315
# g_Define.MOVEMENT_OBJ_SKYBIRD                                  = 316
# g_Define.MOVEMENT_OBJ_PINATA                                   = 317
# g_Define.MOVEMENT_OBJ_TREASUREMAP                              = 318
# g_Define.MOVEMENT_OBJ_CRAFTINGFISHING                          = 319
# g_Define.MOVEMENT_OBJ_CRAFTINGNATURE                           = 320
# g_Define.MOVEMENT_OBJ_POTIONEFFECT                             = 321
# g_Define.MOVEMENT_OBJ_DESKSHOP                                 = 322
# g_Define.MOVEMENT_OBJ_SUPER_TREE                               = 1000
# g_Define.MOVEMENT_OBJ_RECIPE                                   = 1001
# g_Define.MOVEMENT_OBJ_SUPER_TREE_ANI                           = 1002
# g_Define.MOVEMENT_ATTACH_NONE                                  = 0
# g_Define.MOVEMENT_ATTACH_RIDE                                  = 1
# g_Define.MOVEMENT_ATTACH_SWORD1                                = 10
# g_Define.MOVEMENT_ATTACH_SHIELD                                = 11
# g_Define.MOVEMENT_ATTACH_STICKBAR                              = 12
# g_Define.MOVEMENT_ATTACH_FISHING_ROD                           = 30
# g_Define.MOVEMENT_SET_ITEM_DESKTOP                             = 1
# g_Define.MOVEMENT_SET_ITEM_EXTERIOR_FIELD                      = 2
# g_Define.MOVEMENT_FUNC_PET_COLOR_CHANGE                        = 0
# g_Define.MOVEMENT_FUNC_USER_NAMEPLATE                          = 1
# g_Define.MOVEMENT_FUNC_PET_CHANGE                              = 2
# g_Define.MOVEMENT_FUNC_USER_ITEM                               = 3
# g_Define.MOVEMENT_FUNC_CONVERT_BREED_ITEM                      = 9
# g_Define.MOVEMENT_FUNC_GROOMING                                = 10
# g_Define.MOVEMENT_FUNC_PET_SOUND_DLG                           = 100
# g_Define.MOVEMENT_FUNC_PET_ADOPTION                            = 200
# g_Define.MOVEMENT_DIRECT_USE_MAGIC_BOX                         = 1
      Fauxpets.Protocol.Util.encode_byte(Fauxpets.Item.goods_type_to_byte(stack.item.goods_type)) <> # Goods Type
      Fauxpets.Protocol.Util.encode_byte(Fauxpets.Item.what_type_to_byte(stack.item.what_type)) <> # What Type
      Fauxpets.Protocol.Util.encode_int(stack.item.gold) <> # GOLD
      Fauxpets.Protocol.Util.encode_int(stack.item.pink) <> # PINK
      Fauxpets.Protocol.Util.encode_int(stack.item.green) <> # GREEN
      Fauxpets.Protocol.Util.encode_int(stack.item.prize) <> # PRIZE
      Fauxpets.Protocol.Util.encode_short(0) <>
      Fauxpets.Protocol.Util.encode_bool(false) <>
      Fauxpets.Protocol.Util.encode_string("") <> # Breed Field? Weird
      Fauxpets.Protocol.Util.encode_float(1.0) <>
      Fauxpets.Protocol.Util.encode_float(1.0) <>
      Fauxpets.Protocol.Util.encode_float(1.0) <>
      Fauxpets.Protocol.Util.encode_float(1.0) <>
      Fauxpets.Protocol.Util.encode_float(1.0) <>
      Fauxpets.Protocol.Util.encode_string(stack.item.name) <> # Item Name
      Fauxpets.Protocol.Util.encode_string("test3") <>
      Fauxpets.Protocol.Util.encode_bool(false) <> # Customizable?
      Fauxpets.Protocol.Util.encode_int(0) <>
      Fauxpets.Protocol.Util.encode_int(0) <> # Reverse bitmask for gift/stall icons? 0x1 masks out gift, 0x2 masks out stall
      Fauxpets.Protocol.Util.encode_byte(stack.item.use_level) <> # Use Level
      Fauxpets.Protocol.Util.encode_string("") <> # Maker
      Fauxpets.Protocol.Util.encode_int(0) <>
      Fauxpets.Protocol.Util.encode_int(stack.item.physical) <> # Physical
      Fauxpets.Protocol.Util.encode_int(stack.item.energy) <> # Energy
      Fauxpets.Protocol.Util.encode_int(stack.item.karma) <> # Karma
      Fauxpets.Protocol.Util.encode_int(stack.item.buff_time) <> # Buff Time?
      Fauxpets.Protocol.Util.encode_byte(0) <> # Quest?
      Fauxpets.Protocol.Util.encode_float(1.0) <>
      Fauxpets.Protocol.Util.encode_float(1.0) <>
      Fauxpets.Protocol.Util.encode_float(1.0)

      append_stacks(packet, tail)
  end

  defp append_gifts(packet, []) do
    packet
  end

  defp append_gifts(packet, [gift | tail]) do
    packet =
      packet <>
    Fauxpets.Protocol.Util.encode_short(gift.slot_index) <> # SLOT NUMBER (0 indexed?)
    Fauxpets.Protocol.Util.encode_byte(6) <>

    # missing COD, gotta figure that out later
    Fauxpets.Protocol.Util.encode_int(gift.item.id) <>
    Fauxpets.Protocol.Util.encode_string("") <>
    Fauxpets.Protocol.Util.encode_int(0) <> # wrapping ID?
    Fauxpets.Protocol.Util.encode_int(gift.item.item_quantity) <>
    Fauxpets.Protocol.Util.encode_byte(1) <>
    Fauxpets.Protocol.Util.encode_byte(1)
    append_gifts(packet, tail)
  end

  def send_inventory_packet(socket, transport, [inv_no: inv_no, inventory: inventory]) do
    packet = Fauxpets.Protocol.Util.encode_short(inv_no) <> # Inventory Number
    Fauxpets.Protocol.Util.encode_short(length(inventory.stacks)) # Number of Items

    packet = append_stacks(packet, inventory.stacks)

    Logger.info("(inventory: #{inspect(packet)})")

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BCC, packet))
  end


  def send_giftbox_packet(socket, transport, [inv_no: inv_no, giftbox: giftbox]) do
    packet = Fauxpets.Protocol.Util.encode_short(inv_no) <> # Inventory Number
    Fauxpets.Protocol.Util.encode_short(length(giftbox.gifts)) # Number of Items

    packet = append_gifts(packet, giftbox.gifts)

    Logger.info("(giftbox: #{inspect(packet)})")

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BCC, packet))
  end

  @impl true
  def send_packet(socket, transport, [inv_no: inv_no, box: box]) do
    Logger.info("InventoryListStart send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BCD,
      Fauxpets.Protocol.Util.encode_short(inv_no) <>
      Fauxpets.Protocol.Util.encode_string(box.name)
    ))

    Logger.info("InventoryList send for Inventory (inventory: #{inspect(box.inventory)})")
    send_inventory_packet(socket, transport, inv_no: inv_no, inventory: box.inventory)

    Logger.info("InventoryList send for Giftbox (giftbox: #{inspect(box.giftbox)})")
    send_giftbox_packet(socket, transport, inv_no: inv_no, giftbox: box.giftbox)

    Logger.info("InventoryListEnd send")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C21, <<>>))
  end

  # def send_packet(socket, transport, [len: len, inv_no: inv_no, slot_no: slot_no]) do
  #   Logger.info("InventoryList send")
  #   transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BCC,
  #     # FOR SLOT TYPE 1 (IKU)
  #     #Fauxpets.Protocol.Util.encode_int(1) <>
  #     #Fauxpets.Protocol.Util.encode_int(10809) <> # ICON ID
  #     #Fauxpets.Protocol.Util.encode_int(10809) <>
  #     #Fauxpets.Protocol.Util.encode_string("What")))
  #     # FOR SLOT TYPE 5
  #     #Fauxpets.Protocol.Util.encode_int(0) <>
  #     #Fauxpets.Protocol.Util.encode_int(0) <>
  #     #Fauxpets.Protocol.Util.encode_int(40002) <> # THIS SEEMS TO BE THE ITEM ID??????
  #     #Fauxpets.Protocol.Util.encode_int(1) <>
  #     #Fauxpets.Protocol.Util.encode_int(1) <>
  #     #Fauxpets.Protocol.Util.encode_string("What")))
  # end
end
