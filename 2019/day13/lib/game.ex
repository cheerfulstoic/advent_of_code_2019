defmodule Game do
  def get_tiles(map \\ %{}, score \\ nil) do
    with {:ok, x} <- Intcode.receive_output(),
         {:ok, y} <- Intcode.receive_output(),
         {:ok, tile_id} <- Intcode.receive_output() do
      case {x, y} do
        {-1, 0} -> get_tiles(map, tile_id)
        {x, y} -> 
          tile = case tile_id do
            0 -> :empty
            1 -> :wall
            2 -> :block
            3 -> :paddle
            4 -> :ball
          end

          get_tiles(Map.put(map, {x, y}, tile), score)
      end
    else
      {:error, _} -> {map, score}
    end
  end

  def render(map, score) do
    positions = Map.keys(map)
    max_x = Stream.map(positions, fn {x, _} -> x end) |> Enum.max()
    max_y = Stream.map(positions, fn {_, y} -> y end) |> Enum.max()

    Enum.map((0..max_y), fn y ->
      Enum.map((0..max_x), fn x ->
        case Map.get(map, {x, y}, :empty) do
          :empty -> " "
          :wall -> "|"
          :block -> "#"
          :paddle -> "_"
          :ball -> "."
        end
      end) |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    IO.puts(score)
  end

  def run(task_pid, map \\ %{}, score \\ nil) do
    {map, score} = Game.get_tiles(map, score)

    block_count = Map.values(map) |> Enum.count(& &1 == :block)
    if block_count > 0 do
      Game.render(map, score)

      {{ball_x, _}, :ball} = Enum.find(map, fn {pos, tile} -> tile == :ball end)
      {{paddle_x, _}, :paddle} = Enum.find(map, fn {pos, tile} -> tile == :paddle end)

      direction = cond do
        paddle_x < ball_x -> 1
        paddle_x > ball_x -> -1
        true -> 0
      end
      send(task_pid, {:output, direction})

      run(task_pid, map, score)
    else
      IO.inspect(score, label: :score)
    end
  end
end
