defmodule Fauxpets.Protocol.Client.CreatePet do
  require Logger
  @behaviour Fauxpets.Protocol.ClientPacket

  @impl true
  def parse_packet(data) do
    {:ok, unknown_byte_a, rest} = Fauxpets.Protocol.Util.pop_byte(data)
    {:ok, name, rest} = Fauxpets.Protocol.Util.pop_string(rest)
    {:ok, breed, rest} = Fauxpets.Protocol.Util.pop_byte(rest)
    {:ok, gender, rest} = Fauxpets.Protocol.Util.pop_byte(rest)
    {:ok, unknown_string_a, rest} = Fauxpets.Protocol.Util.pop_string(rest)
    {:ok, eye_color, rest} = Fauxpets.Protocol.Util.pop_int(rest)
    {:ok, num_bg, rest} = Fauxpets.Protocol.Util.pop_int(rest)
    {:ok, fur_color, rest} = Fauxpets.Protocol.Util.pop_int(rest)
    {:ok, pattern, rest} = Fauxpets.Protocol.Util.pop_string(rest)
    {:ok, pattern_type, rest} = Fauxpets.Protocol.Util.pop_int(rest)
    {:ok, pattern_color, rest} = Fauxpets.Protocol.Util.pop_int(rest)
    {:ok, num_belly, rest} = Fauxpets.Protocol.Util.pop_int(rest)
    {:ok, belly_color, rest} = Fauxpets.Protocol.Util.pop_int(rest)
    {:ok, unknown_int_b, rest} = Fauxpets.Protocol.Util.pop_int(rest)

    unknown_int_c =
      if unknown_byte_a == 0x01 do
        {:ok, c, _rest} = Fauxpets.Protocol.Util.pop_int(rest)
        c
      else
        0
      end

    [
      byte_a: unknown_byte_a,
      name: name,
      breed: breed,
      gender: gender,
      str_a: unknown_string_a,
      eye_color: eye_color,
      num_bg: num_bg,
      fur_color: fur_color,
      pattern: pattern,
      pattern_type: pattern_type,
      pattern_color: pattern_color,
      num_belly: num_belly,
      belly_color: belly_color,
      int_b: unknown_int_b,
      int_c: unknown_int_c
    ]
  end

  @impl true
  def handle_packet(_socket, _transport, _conn_state,
        byte_a: unknown_byte_a,
        name: name,
        breed: breed,
        gender: gender,
        str_a: unknown_string_a,
        eye_color: eye_color,
        num_bg: num_bg,
        fur_color: fur_color,
        pattern: pattern,
        pattern_type: pattern_type,
        pattern_color: pattern_color,
        num_belly: num_belly,
        belly_color: belly_color,
        int_b: unknown_int_b,
        int_c: unknown_int_c
      ) do
    Logger.info(
      "Pet information: Flag: #{unknown_byte_a}, Name: #{name}, Breed: #{breed}, Gender: #{gender},
    Unknown String: #{unknown_string_a}, Eye Color: #{eye_color}, Num BG: #{num_bg}, Fur Color: #{fur_color},
    Pattern: #{pattern}, Pattern Type: #{pattern_type}, Pattern Color #{pattern_color}, Num Belly: #{num_belly},
    Belly Color: #{belly_color}, Unknown Int B: #{unknown_int_b}, Unknown Int C: #{unknown_int_c}"
    )
  end
end
