defmodule Fauxpets.Protocol.ServerPacket do
  @callback send_packet(
              socket :: :ranch_transport.socket(),
              transport :: :ranch_transport,
              data :: keyword()
            ) :: no_return()
end
