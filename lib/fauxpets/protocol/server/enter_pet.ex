defmodule Fauxpets.Protocol.Server.EnterPet do
  require Logger
  @behaviour Fauxpets.Protocol.ServerPacket

  def send_packet(socket, transport, _args) do
    transport.send(socket, Fauxpets.Protocol.Util.create_packet(0x1E14,
        Fauxpets.Protocol.Util.encode_int(1) <>
        Fauxpets.Protocol.Util.encode_byte(0) <>
        Fauxpets.Protocol.Util.encode_int(1) <>
        Fauxpets.Protocol.Util.encode_bool(true) <> # gender?
        Fauxpets.Protocol.Util.encode_string("Dipshit") <> # pet name
        Fauxpets.Protocol.Util.encode_string("admin") <> # owner id
        Fauxpets.Protocol.Util.encode_byte(1) <> # owner level?
        Fauxpets.Protocol.Util.encode_string("test3") <>
        Fauxpets.Protocol.Util.encode_int(1023) <>
        Fauxpets.Protocol.Util.encode_bool(false) <>
        Fauxpets.Protocol.Util.encode_bool(true) <>
        Fauxpets.Protocol.Util.encode_bool(false) <>
        Fauxpets.Protocol.Util.encode_int(0) <>
        Fauxpets.Protocol.Util.encode_short(0) <>
        Fauxpets.Protocol.Util.encode_byte(0) <>
        Fauxpets.Protocol.Util.encode_float(0.01) <> # Fullness
        Fauxpets.Protocol.Util.encode_float(1.0) <> # Hydration
        Fauxpets.Protocol.Util.encode_float(1.0) <> # Cleanliness
        Fauxpets.Protocol.Util.encode_float(1.0) <> # Tiredness
        Fauxpets.Protocol.Util.encode_float(1.0) <> # Health
        Fauxpets.Protocol.Util.encode_float(1.0) <> # Play
        Fauxpets.Protocol.Util.encode_float(1.0) <> # Adventure
        Fauxpets.Protocol.Util.encode_float(1.0) <> # Human Love
        Fauxpets.Protocol.Util.encode_float(1.0) <> # Pet Love
        Fauxpets.Protocol.Util.encode_float(0.0) <>
        Fauxpets.Protocol.Util.encode_float(0.0) <>
        Fauxpets.Protocol.Util.encode_short(128) <>
        Fauxpets.Protocol.Util.encode_short(256) <>
        Fauxpets.Protocol.Util.encode_short(512) <>
        Fauxpets.Protocol.Util.encode_short(1024) <> # portrait revision?
        Fauxpets.Protocol.Util.encode_string("3;")))
  end
end
