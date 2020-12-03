defmodule Intcode do
  def process_code(code, position) do
    IO.inspect(code, label: :code)
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


File.read!("./day2/input")
|> String.split(",")
|> Enum.reject(& &1 == "")
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)
|> List.replace_at(1, 12)
|> List.replace_at(2, 02)
|> Intcode.process_code(0)
