defmodule Fauxpets.Protocol.Util do
  def encode_string(str) do
    str = str <> <<0>>
    len = byte_size(str)
    <<len::size(2)-unit(8)-unsigned-integer-little, str::binary>>
  end

  def encode_int(int) do
    <<int::size(4)-unit(8)-unsigned-integer-little>>
  end

  def encode_short(short) do
    <<short::size(2)-unit(8)-unsigned-integer-little>>
  end

  def encode_byte(byte) do
    <<byte::size(1)-unit(8)-unsigned-integer-little>>
  end

  def encode_bool(bool) do
    if bool do
      <<1::size(1)-unit(8)-unsigned-integer-little>>
    else
      <<0::size(1)-unit(8)-unsigned-integer-little>>
    end
  end

  def encode_float(float) do
    <<float::size(4)-unit(8)-float-little>>
  end

  def create_packet(id, data) do
    len = byte_size(data) + 2

    <<len::size(2)-unit(8)-unsigned-integer-little, id::size(2)-unit(8)-unsigned-integer-little,
      data::binary>>
  end

  def pop_string(data) do
    <<sz::binary-size(2), rest::binary>> = data
    size = :binary.decode_unsigned(sz, :little) - 1
    <<string::binary-size(size), 0::size(1)-unit(8), rest::binary>> = rest
    {:ok, string, rest}
  end
end
