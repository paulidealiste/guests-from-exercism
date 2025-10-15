defmodule PaintByNumber do
  def palette_bit_size(color_count, power \\ 1) do
    if Integer.pow(2, power) >= color_count,
      do: power,
      else: palette_bit_size(color_count, power + 1)
  end

  def empty_picture(), do: <<>>

  def test_picture(), do: <<0b00::2, 0b01::2, 0b10::2, 0b11::2>>

  def prepend_pixel(picture, color_count, pixel_color_index),
    do: <<pixel_color_index::size(palette_bit_size(color_count)), picture::bitstring>>

  def get_first_pixel(<<>>, _color_count), do: nil

  def get_first_pixel(picture, color_count) do
    bitsize = palette_bit_size(color_count)
    <<x::size(bitsize), _rest::bitstring>> = <<picture::bitstring>>
    x
  end

  def drop_first_pixel(<<>>, _color_count), do: <<>>

  def drop_first_pixel(picture, color_count) do
    bitsize = palette_bit_size(color_count)
    <<_x::size(bitsize), rest::bitstring>> = <<picture::bitstring>>
    rest
  end

  def concat_pictures(picture1, picture2), do: <<picture1::bitstring, picture2::bitstring>>
end
