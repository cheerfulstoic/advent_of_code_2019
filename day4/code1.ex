min = 245182
max = 790572

Enum.count(min..max, fn (i) ->
  digits = 
    i
    |> Integer.to_string()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)

  adjacent_pairs =
    digits
    |> Stream.chunk_every(2, 1, :discard)

  two_adjacent_same =
    adjacent_pairs
    |> Enum.any?(fn
      [a, a] -> true
      _ -> false
    end)

  ever_increasing =
    adjacent_pairs
    |> Enum.all?(fn [a, b] -> a <= b end)

  two_adjacent_same &&
    ever_increasing
end)
|> IO.inspect(label: :output)
