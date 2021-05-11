defmodule Fauxpets.Protocol.Client do
  def packet_type(packet_id) do
    case packet_id do
      0x138A ->
        {:ok, :login}

      0x138C ->
        {:ok, :client_disconnect}

      0x1421 ->
        {:ok, :client_interaction}

      0x14A0 ->
        {:ok, :client_information}

      0x142A ->
        {:ok, :open_gift}

      _ ->
        {:error, :unknown_packet_id, "0x" <> Integer.to_string(packet_id, 16)}
    end
  end
end
