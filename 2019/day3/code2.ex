defmodule WireTracer do
  def nodes(steps, previous_nodes \\ [{{0, 0}, 0}])
  def nodes([], previous_nodes), do: previous_nodes
  def nodes([step | rest], previous_nodes) do
    <<direction::binary-size(1), count::binary>> = step
    count = String.to_integer(count)

    {position, count_so_far} = List.first(previous_nodes)
    nodes(rest, [{next_position(position, direction, count), count_so_far + count} | previous_nodes])
  end

  defp next_position({x, y}, "R", count), do: {x + count, y}
  defp next_position({x, y}, "L", count), do: {x - count, y}
  defp next_position({x, y}, "U", count), do: {x, y + count}
  defp next_position({x, y}, "D", count), do: {x, y - count}

  def intersection([ {line1_x1, line1_y1}, {line1_x2, line1_y2} ], [ {line2_x1, line2_y1}, {line2_x2, line2_y2} ]) do

    cond do
      # Parallel lines
      line1_x1 == line1_x2 && line2_x1 == line2_x2 -> nil
      line1_y1 == line1_y2 && line2_y1 == line2_y2 -> nil

      # Perpendicular, line1 is horizontal
      line1_y1 == line1_y2 ->
        if Enum.member?(line1_x1..line1_x2, line2_x1) && Enum.member?(line2_y1..line2_y2, line1_y1) do
          {line2_x1, line1_y1}
        end

      # Perpendicular, line1 is vertical
      true -> nil
        if Enum.member?(line2_x1..line2_x2, line1_x1) && Enum.member?(line1_y1..line1_y2, line2_y1) do
          {line1_x1, line2_y1}
        end
    end
  end

  def distance({x1, y1}, {x2, y2}) do
    abs(y2 - y1) + abs(x2 - x1)
  end
end

[nodes1, nodes2] =
  File.read!("day3/input")
  # File.read!("day3/input.test1")
  # File.read!("day3/input.test2")
  # File.read!("day3/input.test2")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(& String.split(&1, ","))
  |> Enum.map(&WireTracer.nodes/1)

node_pairs1 =
  nodes1
  |> Enum.reverse()
  |> Stream.chunk_every(2, 1, :discard)
  # |> Enum.to_list()
node_pairs2 =
  nodes2
  |> Enum.reverse()
  |> Stream.chunk_every(2, 1, :discard)
  # |> Enum.to_list()

intersections =
  Enum.flat_map(node_pairs1, fn ([{node1_1, count_so_far1_1}, {node1_2, count_so_far1_2}]) ->
    Enum.map(node_pairs2, fn ([{node2_1, count_so_far2_1}, {node2_2, count_so_far2_2}]) ->
      intersection = WireTracer.intersection([node1_1, node1_2], [node2_1, node2_2])
      if intersection do
        {intersection,
          node1_1,
          node2_1,
          count_so_far1_1 + WireTracer.distance(node1_1, intersection) + 
            count_so_far2_1 + WireTracer.distance(node2_1, intersection),
          count_so_far1_1, WireTracer.distance(node1_1, intersection),
            count_so_far2_1, WireTracer.distance(node2_1, intersection)
        }
      end
    end)
  end)
  |> IO.inspect(label: :intersections)
  |> Enum.reject(&is_nil/1)
  |> Enum.reject(fn {intersection, e, f, combined_distance, a, b, c, d} -> intersection == {0, 0} end)
  |> IO.inspect(label: :compacted)
  |> Enum.min_by(fn {_, e, f, combined_distance, a, b, c, d} -> combined_distance end)
  |> IO.inspect(label: :min)



# 13180 is too high
