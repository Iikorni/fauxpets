defmodule Fauxpets.Protocol.ClientPacket do
  @callback handle_packet(data :: binary()) :: keyword()
end
