defmodule Fauxpets.Protocol.Server.OpenGiftItem do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, inv_no: inv_no, slot_index: slot_index) do
    {:ok, dt} = DateTime.now("America/New_York")
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1BFC,
      Fauxpets.Protocol.Util.encode_byte(4) <>
      Fauxpets.Protocol.Util.encode_short(inv_no) <>
      Fauxpets.Protocol.Util.encode_short(slot_index) <>
      Fauxpets.Protocol.Util.encode_int(6) <> # Item ID
      Fauxpets.Protocol.Util.encode_byte(1) <> # Cash on Delivery

      Fauxpets.Protocol.Util.encode_int(100) <>  # Gold?
      Fauxpets.Protocol.Util.encode_int(200) <> # Pink?
      Fauxpets.Protocol.Util.encode_int(300) <> # Green?
      Fauxpets.Protocol.Util.encode_int(50) <> # Prize?

      Fauxpets.Protocol.Util.encode_string("Me") <> # Sender
      Fauxpets.Protocol.Util.encode_string("Eat my ass you absolute buffoon.") <>
      Fauxpets.Protocol.Util.encode_string(Calendar.strftime(dt, "%Y-%m-%d")) <> # Send Data
      Fauxpets.Protocol.Util.encode_int(4) <> # Qty
      Fauxpets.Protocol.Util.encode_byte(0))) # 0 sent / 1 returned

      # return gift 0x1479
      # open gift 0x142B
  end

end
