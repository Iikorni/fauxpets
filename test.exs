defmodule Test do
  def encode_string(str) do
    len = byte_size(str)
    <<len::size(2)-unit(8)-unsigned-integer-little, str::binary>>
  end

  def create_packet(id, data) do
    len = byte_size(data) + 2
    <<len::size(2)-unit(8)-unsigned-integer-little, id::size(2)-unit(8)-unsigned-integer-little, data::binary>>
  end
end
