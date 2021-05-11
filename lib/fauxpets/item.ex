defmodule Fauxpets.Item do
  use Ecto.Schema
  require Logger
  require Ecto.Query

  def what_type_to_byte(what_type) do
    case what_type do
      :none -> 0
      :food -> 1
      :drink -> 2
      :toy -> 3
      :bath -> 4
      :bath_tool -> 5
      :fortune_cookie -> 6
      :subs_reward -> 7
      :decoration -> 8
      :house -> 9
      :countable_useitem -> 10
      :crafting_tool -> 11
      :post -> 12
    end
  end

  def goods_type_to_byte(goods_type) do
    case goods_type do
      :notattach -> 0
      :attach -> 1
      :wrap -> 2
      :setting_item -> 3
      :function -> 4
      :direct_use -> 5
      :game -> 6
      :sound -> 7
      :friendsring -> 8
      :babypet_basket -> 9
      :recipe_book -> 10
      :fishing_place -> 11
      :slot_item -> 12
      :treasurechest -> 13
      :desk_shop -> 14
      :teleport -> 15
      :growing_fruit -> 50
    end
  end

  def reaction_to_short(reaction) do
    case reaction do
      :none -> 0
      :play -> 1
      :eat -> 2
      :drink -> 3
      :sleep_mat -> 4
      :get_flys -> 5
      :sleep_beach_chair -> 6
      :battle_small -> 8
      :dracula_coffin -> 11
      :wear_stickbar -> 12
      :playacade -> 100
      :bathing -> 101
      :oasis_drink -> 102
      :bow_toriigate -> 103
      :fishing -> 104
      :mistletoe -> 105
      :attach_moveani -> 106
      :ride -> 107
      :love_arch -> 108
      :teddybear -> 109
      :cherrytree_turnaround -> 110
      :playamusement -> 111
      :play_ddr -> 112
      :ride_canival_item -> 113
      :play_shoot -> 114
      :turnon_fireplug -> 115
      :turnon_aircon -> 116
      :playaniamusement -> 117
      :campingshower -> 118
      :sectionlooping -> 119
      :bvsitemact -> 120
      :bbpitemact -> 121
      :halfpipe -> 122
      :jukebox -> 123
      :pogostick -> 124
      :simplicity -> 125
      :toughtrunktree -> 126
      :skybird -> 127
      :pinata -> 128
      :treasuremap -> 129
      :craftingfishing -> 130
      :craftingnature -> 131
    end
  end

  schema "items" do
    field(:name, :string)

    field(:reaction, Ecto.Enum,
      values: [
        :none,
        :play,
        :eat,
        :drink,
        :sleep_mat,
        :get_flys,
        :sleep_beach_chair,
        :battle_small,
        :dracula_coffin,
        :wear_stickbar,
        :playacade,
        :bathing,
        :oasis_drink,
        :bow_toriigate,
        :fishing,
        :mistletoe,
        :attach_moveani,
        :ride,
        :love_arch,
        :teddybear,
        :cherrytree_turnaround,
        :playamusement,
        :play_ddr,
        :ride_canival_item,
        :play_shoot,
        :turnon_fireplug,
        :turnon_aircon,
        :playaniamusement,
        :campingshower,
        :sectionlooping,
        :bvsitemact,
        :bbpitemact,
        :halfpipe,
        :jukebox,
        :pogostick,
        :simplicity,
        :toughtrunktree,
        :skybird,
        :pinata,
        :treasuremap,
        :craftingfishing,
        :craftingnature
      ],
      default: :none
    )

    field(:goods_type, Ecto.Enum,
      values: [
        :notattach,
        :attach,
        :wrap,
        :setting_item,
        :function,
        :direct_use,
        :game,
        :sound,
        :friendsring,
        :babypet_basket,
        :recipe_book,
        :fishing_place,
        :slot_item,
        :treasurechest,
        :desk_shop,
        :teleport,
        :growing_fruit
      ],
      default: :notattach
    )

    field(:what_type, Ecto.Enum,
      values: [
        :none,
        :food,
        :drink,
        :toy,
        :bath,
        :bath_tool,
        :fortune_cookie,
        :subs_reward,
        :decoration,
        :house,
        :countable_useitem,
        :crafting_tool,
        :post
      ],
      default: :none
    )

    field(:gold, :integer, default: 0)
    field(:pink, :integer, default: 0)
    field(:green, :integer, default: 0)
    field(:prize, :integer, default: 0)
    field(:use_level, :integer, default: 1)
    field(:physical, :integer, default: 0)
    field(:energy, :integer, default: 0)
    field(:karma, :integer, default: 0)
    field(:buff_time, :integer, default: 0)
  end

  def changeset(item, params \\ %{}) do
    item
    |> Ecto.Changeset.cast(params, [
      :name,
      :reaction,
      :goods_type,
      :what_type,
      :gold,
      :pink,
      :green,
      :prize,
      :use_level,
      :physical,
      :energy,
      :karma,
      :buff_time
    ])
  end
end
