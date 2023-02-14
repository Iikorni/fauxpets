defmodule Fauxpets.Protocol.Client do
  def packet_type(packet_id) do
    case packet_id do
      0x138A ->
        {:ok, Fauxpets.Protocol.Client.Login}

      0x138C ->
        {:ok, Fauxpets.Protocol.Client.Disconnect}

      0x13F2 ->
        {:ok, Fauxpets.Protocol.Client.CreatePet}

      0x13FF ->
        {:ok, Fauxpets.Protocol.Client.RequestInventory}

      0x141C ->
        {:ok, Fauxpets.Protocol.Client.RequestUser}

      0x1421 ->
        {:ok, Fauxpets.Protocol.Client.LogGUI}

      0x149E ->
        {:ok, Fauxpets.Protocol.Client.QuestInfo}

      0x149F ->
        {:ok, Fauxpets.Protocol.Client.LangNo}

      0x14A0 ->
        {:ok, Fauxpets.Protocol.Client.ClientInfo}

      0x142A ->
        {:ok, Fauxpets.Protocol.Client.OpenGift}

      _ ->
        {:error, :unknown_packet_id, "0x" <> Integer.to_string(packet_id, 16)}
    end
  end
end
