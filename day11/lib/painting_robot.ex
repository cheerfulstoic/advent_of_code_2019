defmodule PaintingRobot do
  def start_state do
    {%{{0, 0} => :white}, {{0, 0}, :up}}
  end

  def paint({map, {position, direction}}, color), do: {Map.put(map, position, color), {position, direction}}

  def turn({map, {position, direction}}, turn_direction), do: {map, {position, new_direction(direction, turn_direction)}}
  defp new_direction(:up, :left), do: :left
  defp new_direction(:left, :left), do: :down
  defp new_direction(:down, :left), do: :right
  defp new_direction(:right, :left), do: :up
  defp new_direction(:up, :right), do: :right
  defp new_direction(:left, :right), do: :up
  defp new_direction(:down, :right), do: :left
  defp new_direction(:right, :right), do: :down

  def advance({map, {position, direction}}), do: {map, {advanced_position(position, direction), direction}}
  defp advanced_position({x, y}, :up), do: {x, y + 1}
  defp advanced_position({x, y}, :left), do: {x - 1, y}
  defp advanced_position({x, y}, :down), do: {x, y - 1}
  defp advanced_position({x, y}, :right), do: {x + 1, y}

  def current_color({map, {position, direction}}), do: Map.get(map, position, :black)

  def display({map, _}) do
    xs = Map.keys(map) |> Enum.map(fn {x, _} -> x end)
    ys = Map.keys(map) |> Enum.map(fn {_, y} -> y end)

    min_x = Enum.min(xs)
    max_x = Enum.max(xs)

    min_y = Enum.min(ys)
    max_y = Enum.max(ys)


    Enum.map(max_y..min_y, fn y ->
      Enum.map(min_x..max_x, fn x ->
        color = Map.get(map, {x, y}, :black)
        case color do
          :white -> "#"
          :black -> " "
        end
      end) |> Enum.join("")
    end) |> Enum.join("\n")
    |> IO.puts()
  end
end

