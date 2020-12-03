defmodule Intcode do
  def list_to_memory(list) do
    Stream.with_index(list)
    |> Enum.reduce(%{}, fn {value, index}, result -> Map.put(result, index, value) end)
  end

  def slice_memory(_, _, 0), do: []
  def slice_memory(memory, position, count) do
    Enum.map(position..position + count - 1, fn (current_position) ->
      Map.get(memory, current_position) || 0
    end)
  end

  def process_memory(memory, output_pids, nil, nil), do: memory # op_code 99
  def process_memory(memory, output_pids, position \\ 0, relative_base \\ 0) do
    reversed_digits =
      memory
      |> Map.get(position)
      |> Integer.to_string()
      |> String.reverse()
      |> String.codepoints()

    op_code =
      reversed_digits
      |> Enum.take(2)
      |> Enum.join("")
      |> String.reverse()
      |> String.to_integer()
      |> log(:op_code)

    instruction_count = instruction_count(op_code)

    modes =
      (2..2 + instruction_count - 1)
      |> Enum.map(& Enum.at(reversed_digits, &1) || "0")
      |> Enum.map(&String.to_integer/1)

    values = slice_memory(memory, position + 1, instruction_count)

    values_and_modes = Enum.zip(values, modes)
      |> log(:values_and_modes)

    log(position, :position)
    {new_memory, new_position, new_relative_base} = process_instruction(%{
      memory: memory,
      output_pids: output_pids,
      relative_base: relative_base
    }, position, op_code, values_and_modes)

    process_memory(new_memory, output_pids, new_position, new_relative_base)
  end

  # Add
  def instruction_count(1), do: 3
  def process_instruction(%{memory: memory, relative_base: relative_base}, position, 1, [int_and_mode1, int_and_mode2, result_int_and_mode]) do
    {
      Map.put(memory, result_position(result_int_and_mode, relative_base), value_for(memory, int_and_mode1, relative_base) + value_for(memory, int_and_mode2, relative_base)),
      position + 4,
      relative_base
    }
  end

  # Multiply
  def instruction_count(2), do: 3
  def process_instruction(%{memory: memory, relative_base: relative_base}, position, 2, [int_and_mode1, int_and_mode2, result_int_and_mode]) do
    {
      Map.put(memory, result_position(result_int_and_mode, relative_base), value_for(memory, int_and_mode1, relative_base) * value_for(memory, int_and_mode2, relative_base)),
      position + 4,
      relative_base
    }
  end

  # Get input
  def instruction_count(3), do: 1
  def process_instruction(%{memory: memory, relative_base: relative_base}, position, 3, [result_int_and_mode]) do
    value =
      receive do
        {:output, value} ->
          log(value, "Got value")
          value
      end

    {
      # Map.put(memory, value_for(memory, result_int_and_mode, relative_base), value),
      Map.put(memory, result_position(result_int_and_mode, relative_base), value),
      position + 2,
      relative_base
    }
  end

  # Output
  def instruction_count(4), do: 1
  def process_instruction(%{memory: memory, output_pids: output_pids, relative_base: relative_base}, position, 4, [int_and_mode]) do
    value = value_for(memory, int_and_mode, relative_base)

    log(value, "OUTPUT")
    for output_pid <- output_pids do
      log(output_pid, "sending to")
      send(output_pid, {:output, value})
    end

    { memory, position + 2, relative_base }
  end

  # jump-if-true
  def instruction_count(5), do: 2
  def process_instruction(%{memory: memory, relative_base: relative_base}, position, 5, [value_int_and_mode, position_int_and_mode]) do
    if value_for(memory, value_int_and_mode, relative_base) > 0 do
      {memory, value_for(memory, position_int_and_mode, relative_base), relative_base}
    else
      {memory, position + 3, relative_base }
    end
  end

  # jump-if-false
  def instruction_count(6), do: 2
  def process_instruction(%{memory: memory, relative_base: relative_base}, position, 6, [value_int_and_mode, position_int_and_mode]) do
    if value_for(memory, value_int_and_mode, relative_base) == 0 do
      {memory, value_for(memory, position_int_and_mode, relative_base), relative_base}
    else
      {memory, position + 3, relative_base }
    end
  end

  # less than
  def instruction_count(7), do: 3
  def process_instruction(%{memory: memory, relative_base: relative_base}, position, 7, [int_and_mode1, int_and_mode2, result_int_and_mode]) do
    value = if(value_for(memory, int_and_mode1, relative_base) < value_for(memory, int_and_mode2, relative_base), do: 1, else: 0)

    {
      Map.put(memory, result_position(result_int_and_mode, relative_base), value),
      position + 4,
      relative_base
    }
  end

  # Compare / equality
  def instruction_count(8), do: 3
  def process_instruction(%{memory: memory, relative_base: relative_base}, position, 8, [int_and_mode1, int_and_mode2, result_int_and_mode]) do
    value = if(value_for(memory, int_and_mode1, relative_base) == value_for(memory, int_and_mode2, relative_base), do: 1, else: 0)

    {
      Map.put(memory, result_position(result_int_and_mode, relative_base), value),
      position + 4,
      relative_base
    }
  end

  # Change relative base
  def instruction_count(9), do: 1
  def process_instruction(%{memory: memory, relative_base: relative_base}, position, 9, [int_and_mode]) do
    {memory, position + 2, relative_base + value_for(memory, int_and_mode, relative_base)}
  end

  # Halt
  def instruction_count(99), do: 0
  def process_instruction(%{memory: memory}, position, 99, []), do: {memory, nil, nil}


  # Position mode
  defp value_for(memory, {position, 0}, _relative_base), do: Map.get(memory, position) || 0
  # Immediate mode
  defp value_for(_memory, {value, 1}, _relative_base), do: value
  # Relative mode
  defp value_for(memory, {position, 2}, relative_base), do: Map.get(memory, relative_base + position) || 0

  defp log(value, label) do
    # IO.puts("#{inspect self()}: #{label}: #{inspect value}")

    value
  end

  defp result_position(result_int_and_mode, relative_base) do
    case result_int_and_mode do
      {int, 0} -> int
      {int, 2} -> relative_base + int
    end
  end

  def receive_output do
    receive do
      {:output, output} -> {:ok, output}
    after
      100 -> {:error, "Nothing after 1 second"}
    end
  end

  def receive_outputs do
    {:message_queue_len, length} = Process.info(self(), :message_queue_len)

    Enum.map((0..length-1), fn (_i) ->
      receive do
        {:output, output} -> output
      end
    end)
  end
end

