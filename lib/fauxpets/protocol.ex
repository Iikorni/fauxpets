defmodule Fauxpets.Protocol do
  require Logger
  require Ecto.Query

  @behaviour :ranch_protocol

  def start_link(ref, transport, protocolOptions) do
    pid = spawn_link(__MODULE__, :init, [ref, transport, protocolOptions])
    {:ok, pid}
  end

  def init(ref, transport, _protocolOptions) do
    {:ok, socket} = :ranch.handshake(ref)
    Logger.info("Recieved client connection - sending check version and stream...")

    {:ok, salt} = Application.fetch_env(:fauxpets, :salt)

    Fauxpets.Protocol.Server.StartStream.send_packet(socket, transport, salt: salt)
    Fauxpets.Protocol.Server.CheckVersion.send_packet(socket, transport, version: 0x34)

    {:ok, conn_state} = GenServer.start_link(Fauxpets.ConnectionState, :ok)

    loop(socket, transport, conn_state)
  end

  def loop(socket, transport, conn_state) do
    case transport.recv(socket, 0, 60000 * 5) do
      {:ok, data} ->
        parser(data, socket, transport, conn_state)
        loop(socket, transport, conn_state)

      _ ->
        Logger.info("closing client connection...")
        :ok = transport.close(socket)
    end
  end

  defp parser(data, socket, transport, conn_state) do
    Logger.debug("Got packet: #{inspect(data)}")

    <<packet_size::size(2)-unit(8)-unsigned-integer-little,
      packet_id::size(2)-unit(8)-unsigned-integer-little, rest::binary>> = data

    [rest, tail] =
      if byte_size(rest) + 2 != packet_size do
        chop_size = packet_size - 2
        <<head::binary-size(chop_size), tail::binary>> = rest
        [head, tail]
      else
        [rest, nil]
      end

    case Fauxpets.Protocol.Client.packet_type(packet_id) do
      {:ok, packet_type} ->
          data = apply(packet_type, :parse_packet, [rest])
          apply(packet_type, :handle_packet, [socket, transport, conn_state, data])
      {:error, :unknown_packet_id, id} ->
        Logger.error(
          "Couldn't respond to packet #{id}... (#{inspect(rest, binaries: :as_binaries)})"
        )
    end

    if tail != nil do
      total_len = byte_size(data)
      expected_len = packet_size + 2
      Logger.debug("Length #{total_len} was not #{expected_len}! Resending...")
      parser(tail, socket, transport, conn_state)
    end
  end
end
