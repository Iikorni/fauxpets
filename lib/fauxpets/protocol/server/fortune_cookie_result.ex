defmodule Fauxpets.Protocol.Server.FortuneCookieResult do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  defp get_fortune_type(type) do
    case type do
      :gold -> {:ok, 0}
      :pink -> {:ok, 1}
      :green -> {:ok, 2}
      _ -> {:error, :bad_fortune_type}
    end
  end

  def send_packet(socket, transport, [type: type, gold: gold, pink: pink, green: green, item: item]) do
    {:ok, fortune_type} = get_fortune_type(type)
    Logger.info("FortuneCookieResult send... #{type}, #{gold}, #{pink}, #{green}, #{item}")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1C0E,
      Fauxpets.Protocol.Util.encode_byte(fortune_type) <>
      Fauxpets.Protocol.Util.encode_int(gold) <>
      Fauxpets.Protocol.Util.encode_int(pink) <>
      Fauxpets.Protocol.Util.encode_int(green) <>
      Fauxpets.Protocol.Util.encode_int(item)))
  end
end
