defmodule Intcode do
  def process_code(code, position) do
    [instruction, position1, position2, result_position] = Enum.slice(code, position, 4)
    value1 = Enum.at(code, position1)
    value2 = Enum.at(code, position2)

    case instruction do
      1 -> process_code(List.replace_at(code, result_position, value1 + value2), position + 4)
      2 -> process_code(List.replace_at(code, result_position, value1 * value2), position + 4)
      99 -> code
    end
  end
end

combinations = for a <- (1..100), b <- (1..100), do: {a, b}

Enum.find(combinations, fn {a, b} ->
  IO.inspect "a: #{a}, b: #{b}"

  result =
    File.read!("./day2/input")
    |> String.split(",")
    |> Enum.reject(& &1 == "")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, a)
    |> List.replace_at(2, b)
    |> Intcode.process_code(0)

  List.first(result) == 19690720
end)
|> IO.inspect(label: :found)
