Code.require_file("./lib/intcode.ex")

result =
  File.read!("./input")
  |> String.split(",")
  |> Enum.reject(& &1 == "")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.to_integer/1)
  |> Intcode.process_memory()
  |> IO.inspect(label: :result)

