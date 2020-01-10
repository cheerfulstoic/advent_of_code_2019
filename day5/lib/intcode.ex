defmodule Intcode do
  def process_memory(memory, nil), do: memory # op_code 99
  def process_memory(memory, position \\ 0) do
    # IO.inspect(memory)
    reversed_digits =
      memory
      |> Enum.at(position)
      |> Integer.to_string()
      |> String.reverse()
      |> String.codepoints()

    op_code =
      reversed_digits
      |> Enum.take(2)
      |> Enum.join("")
      |> String.reverse()
      |> String.to_integer()
      |> IO.inspect(label: :op_code)

    instruction_count = instruction_count(op_code)

    modes =
      (2..2 + instruction_count - 1)
      |> Enum.map(& Enum.at(reversed_digits, &1) || "0")
      |> Enum.map(&String.to_integer/1)

    values = Enum.slice(memory, position + 1, instruction_count)

    values_and_modes = Enum.zip(values, modes)

    # IO.inspect(op_code, label: :op_code)
    {new_memory, new_position} = process_instruction(memory, position, op_code, values_and_modes)

    process_memory(new_memory, new_position)
  end

  def instruction_count(1), do: 3
  def process_instruction(memory, position, 1, [int_and_mode1, int_and_mode2, {result_position, _}]) do
    {
      List.replace_at(memory, result_position, value_for(memory, int_and_mode1) + value_for(memory, int_and_mode2)),
      position + 4
    }
  end

  def instruction_count(2), do: 3
  def process_instruction(memory, position, 2, [int_and_mode1, int_and_mode2, {result_position, _}]) do
    {
      List.replace_at(memory, result_position, value_for(memory, int_and_mode1) * value_for(memory, int_and_mode2)),
      position + 4
    }
  end

  def instruction_count(3), do: 1
  def process_instruction(memory, position, 3, [{result_position, _}]) do
    {
      List.replace_at(memory, result_position, 5), # Hard-code 5 for now
      position + 2
    }
  end

  def instruction_count(4), do: 1
  def process_instruction(memory, position, 4, [{result_position, mode}]) do
    IO.puts("OUTPUT: #{value_for(memory, {result_position, mode})}")

    { memory, position + 2 }
  end

  # jump-if-true
  def instruction_count(5), do: 2
  def process_instruction(memory,  position, 5, [value_int_and_mode, position_int_and_mode]) do
    if value_for(memory, value_int_and_mode) > 0 do
      {memory, value_for(memory, position_int_and_mode)}
    else
      {memory, position + 3}
    end
  end

  # jump-if-false
  def instruction_count(6), do: 2
  def process_instruction(memory, position, 6, [value_int_and_mode, position_int_and_mode]) do
    if value_for(memory, value_int_and_mode) == 0 do
      {memory, value_for(memory, position_int_and_mode)}
    else
      {memory, position + 3}
    end
  end

  # less than
  def instruction_count(7), do: 3
  def process_instruction(memory, position, 7, [int_and_mode1, int_and_mode2, {result_position, _}]) do
    value = if(value_for(memory, int_and_mode1) < value_for(memory, int_and_mode2), do: 1, else: 0)

    {
      List.replace_at(memory, result_position, value),
      position + 4
    }
  end

  def instruction_count(8), do: 3
  def process_instruction(memory, position, 8, [int_and_mode1, int_and_mode2, {result_position, _}]) do
    value = if(value_for(memory, int_and_mode1) == value_for(memory, int_and_mode2), do: 1, else: 0)

    {
      List.replace_at(memory, result_position, value),
      position + 4
    }
  end

  def instruction_count(99), do: 0
  def process_instruction(memory, position, 99, []), do: {memory, nil}


  # Position mode
  defp value_for(memory, {position, 0}), do: Enum.at(memory, position)
  # Immediate mode
  defp value_for(_memory, {value, 1}), do: value
end

