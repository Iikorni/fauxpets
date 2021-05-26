defmodule Fauxpets.Protocol.Client.CreatePet do
  require Logger
  @behaviour Fauxpets.Protocol.ClientPacket

  @impl true
  def handle_packet(data) do
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
      {:ok, unknown_int_c, rest} = Fauxpets.Protocol.Util.pop_int(rest)
      unknown_int_d = if unknown_byte_a == 0x01 do
        {:ok, d, _rest} = Fauxpets.Protocol.Util.pop_int(rest)
        d
      else
        0
      end

      Logger.info("Pet information: Flag: #{unknown_byte_a}, Name: #{name}, Breed: #{breed}, Gender: #{gender},
      Unknown String: #{unknown_string_a}, Eye Color: #{eye_color}, Num BG: #{num_bg}, Fur Color: #{fur_color},
      Pattern: #{pattern}, Pattern Type: #{pattern_type}, Pattern Color #{pattern_color}, Num Belly: #{num_belly},
      Belly Color: #{belly_color}, Unknown Int C: #{unknown_int_c}, Unknown Int D: #{unknown_int_d}")
  end
end
