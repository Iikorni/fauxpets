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
  def parse_packet(data) do
    <<id::size(4)-unit(8)-unsigned-integer-little, _rest::binary>> = data

    resp = case id do
      1 ->
        {:ok, :lang_ko}

      2 ->
        {:ok, :lang_en}

      3 ->
        {:ok, :lang_zh}

      4 ->
        {:ok, :lang_ja}

      5 ->
        {:ok, :lang_zh_cn}

      6 ->
        {:ok, :lang_th}

      7 ->
        {:ok, :lang_en_ph}

      8 ->
        {:ok, :lang_fr}

      9 ->
        {:ok, :lang_de}

      10 ->
        {:ok, :lang_es}

      11 ->
        {:ok, :lang_it}

      12 ->
        {:ok, :lang_pt}

      13 ->
        {:ok, :lang_nl}

      14 ->
        {:ok, :lang_dan}

      _ ->
        {:error, :unknown_code, data}
    end
    [lang: resp]
  end

  @impl true
  def handle_packet(_socket, _transport, _conn_state, [lang: {:ok, lang}]) do
    Logger.info("Client reports language '#{Fauxpets.Protocol.Client.LangNo.lang_to_str(lang)}'")
  end

  @impl true
  def handle_packet(_socket, _transport, _conn_state, [lang: {:error, :unknown_code, data}]) do
    Logger.info("Client reports unknown language with data '#{inspect(data, binaries: :as_binaries)}'")
  end
end
