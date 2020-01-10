defmodule ImageReader do

  def layers(""), do: []

  # 150 = 26 * 6
  def layers(<<layer_data :: binary-size(150), rest :: binary>>) do

    [layer_data | layers(rest)]
  end

  def count_char("", char), do: 0

  def count_char(<<first :: binary-size(1), rest :: binary>>, char) do
    count_char(rest, char) + if(first == char, do: 1, else: 0)
  end

end

width = 25
height = 6

layer =
  File.read!("input")
  |> String.trim()
  |> ImageReader.layers()
  |> Enum.min_by(fn (layer) ->
    ImageReader.count_char(layer, "0")
  end)

IO.inspect(layer)

result =
  ImageReader.count_char(layer, "1") *
  ImageReader.count_char(layer, "2")

IO.inspect(result, label: :result)

