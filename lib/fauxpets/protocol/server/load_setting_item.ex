defmodule Fauxpets.Protocol.Server.LoadSettingItem do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  defp type_to_short(type) do
    case type do
      :desktop -> 1
      :skybox -> 2
      _ -> raise "bad settype #{type}"
    end
  end

  def send_packet(socket, transport, type: type) do
    Logger.info("SettingItem send... (type: #{type})")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1D4E,
      Fauxpets.Protocol.Util.encode_short(type_to_short(:desktop)) <>
      Fauxpets.Protocol.Util.encode_int(0) <>
      Fauxpets.Protocol.Util.encode_short(type_to_short(:skybox)) <>
      Fauxpets.Protocol.Util.encode_int(0)))
  end
end
