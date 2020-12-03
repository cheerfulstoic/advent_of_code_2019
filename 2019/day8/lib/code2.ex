defmodule ImageReader do

  def layers(""), do: []

  # 150 = 26 * 6
  def layers(<<layer_data :: binary-size(150), rest :: binary>>) do
    [layer_data | layers(rest)]
  end
end

width = 25

resulting_layer =
  File.read!("input")
  |> String.trim()
  |> ImageReader.layers()
  |> Enum.map(& String.codepoints(&1))
  |> Enum.zip()
  |> Enum.map(fn (pixel_layers) ->
    pixel_layers
    |> Tuple.to_list()
    |> Enum.find(& &1 != "2")
  end)
  |> Enum.map(& if(&1 == "1", do: "+", else: " "))
  |> Enum.chunk_every(width, width)
  |> Enum.each(& IO.puts(Enum.join(&1, "")))

