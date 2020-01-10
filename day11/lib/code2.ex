
Code.require_file("./lib/intcode.ex")
Code.require_file("./lib/painting_robot.ex")

# Game is 46 x 26

defmodule Foo do
  def run(robot_state, robot_pid) do
    IO.inspect(Process.alive?(robot_pid), label: :alive)
    if Process.alive?(robot_pid) do
      color_value =
        case PaintingRobot.current_color(robot_state) do
          :black -> 0
          :white -> 1
        end

      send(robot_pid, {:output, color_value})

      with {:ok, new_color_value} <- Intcode.receive_output(),
           {:ok, turn_value} <- Intcode.receive_output() do

        new_color = case new_color_value do
          0 -> :black
          1 -> :white
        end

        turn = case turn_value do
          0 -> :left
          1 -> :right
        end

        robot_state
        |> PaintingRobot.paint(new_color)
        |> PaintingRobot.turn(turn)
        |> PaintingRobot.advance()
        |> run(robot_pid)
      else
        {:error, message} -> robot_state
      end
    else
      robot_state
    end
  end
end

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

robot_state = PaintingRobot.start_state()

final_state = Foo.run(robot_state, task.pid)
              |> IO.inspect(label: :final_state)

{map, {position, direction}} = final_state

PaintingRobot.display(final_state)
