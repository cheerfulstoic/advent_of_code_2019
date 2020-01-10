Code.require_file("./lib/intcode.ex")

memory =
  File.read!("./input")
  |> String.split(",")
  |> Enum.reject(& &1 == "")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.to_integer/1)
  |> Intcode.list_to_memory()

send(self(), {:output, 1})
Intcode.process_memory(memory, [self()])

values = Intcode.receive_outputs()

IO.inspect(values, label: :values)


# 3717687000 is too low
