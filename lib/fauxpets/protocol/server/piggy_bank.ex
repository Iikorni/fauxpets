defmodule Fauxpets.Protocol.Server.PiggyBank do
  require Logger

  @behaviour Fauxpets.Protocol.ServerPacket

  @impl true
  def send_packet(socket, transport, gold: gold, pink: pink, green: green, prize: prize) do
    Logger.info("PiggyBank send (gold: #{gold}, pink: #{pink}, green: #{green}, prize: #{prize})")

    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1bd8,
      Fauxpets.Protocol.Util.encode_int(gold) <>
      Fauxpets.Protocol.Util.encode_int(pink) <>
      Fauxpets.Protocol.Util.encode_int(green) <>
      Fauxpets.Protocol.Util.encode_int(prize)))
  end
end
