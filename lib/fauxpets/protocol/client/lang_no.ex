defmodule Fauxpets.Protocol.Client.LangNo do
  @behaviour Fauxpets.Protocol.ClientPacket
  require Logger

  def lang_to_str(lang) do
    case lang do
      :lang_ko -> "Korean"
      :lang_en -> "English"
      :lang_zh -> "Chinese (Traditional)"
      :lang_ja -> "Japanese"
      :lang_zh_cn -> "Chinese (Simplified)"
      :lang_th -> "Thai"
      :lang_en_pn -> "Tagalog"
      :lang_fr -> "French"
      :lang_de -> "German"
      :lang_es -> "Spanish"
      :lang_it -> "Italian"
      :lang_pt -> "Portuguese"
      :lang_nl -> "Dutch"
      :lang_dan -> "Danish"
    end
  end

  @impl true
  def handle_packet(data) do
    <<id::size(4)-unit(8)-unsigned-integer-little, _rest::binary>> = data

    case id do
      1 ->
        [resp: {:ok, :lang_ko}]

      2 ->
        [resp: {:ok, :lang_en}]

      3 ->
        [resp: {:ok, :lang_zh}]

      4 ->
        [resp: {:ok, :lang_ja}]

      5 ->
        [resp: {:ok, :lang_zh_cn}]

      6 ->
        [resp: {:ok, :lang_th}]

      7 ->
        [resp: {:ok, :lang_en_ph}]

      8 ->
        [resp: {:ok, :lang_fr}]

      9 ->
        [resp: {:ok, :lang_de}]

      10 ->
        [resp: {:ok, :lang_es}]

      11 ->
        [resp: {:ok, :lang_it}]

      12 ->
        [resp: {:ok, :lang_pt}]

      13 ->
        [resp: {:ok, :lang_nl}]

      14 ->
        [resp: {:ok, :lang_dan}]

      _ ->
        [resp: {:error, :unknown_code, data}]
    end
  end
end
