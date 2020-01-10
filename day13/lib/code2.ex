
Code.require_file("./lib/intcode.ex")
Code.require_file("./lib/game.ex")


memory =
  File.read!("./input")
  |> String.split(",")
  |> Enum.reject(& &1 == "")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.to_integer/1)
  |> Intcode.list_to_memory()

main_pid = self()

task =
  Task.async(fn ->
    Intcode.process_memory(memory, [main_pid])
  end)

Game.run(task.pid)

