defmodule Fauxpets.Protocol.ClientPacket do
  @callback parse_packet(data :: binary()) :: keyword()
  @callback handle_packet(
              socket :: :ranch_transport.socket(),
              transport :: :ranch_transport,
              conn_state :: any(),
              data :: keyword()
            ) :: no_return()
end
