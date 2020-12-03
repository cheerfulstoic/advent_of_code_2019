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

  there_is_a_pair =
    digits
    |> Stream.chunk_by(& &1)
    |> Enum.map(&length/1)
    |> Enum.any?(& &1 == 2)

  ever_increasing =
    adjacent_pairs
    |> Enum.all?(fn [a, b] -> a <= b end)

  there_is_a_pair &&
    ever_increasing
end)
|> IO.inspect(label: :output)


# 659 is too low
#
# 628 is also too low, duh
#
# 440 is also too low, duh
