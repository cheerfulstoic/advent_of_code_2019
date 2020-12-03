defmodule WireTracer do
  def nodes(steps, previous_nodes \\ [{0, 0}])
  def nodes([], previous_nodes), do: previous_nodes
  def nodes([step | rest], previous_nodes) do
    nodes(rest, [next_position(List.first(previous_nodes), step) | previous_nodes])
  end

  defp next_position({x, y}, <<"R", count::binary>>), do: {x + String.to_integer(count), y}
  defp next_position({x, y}, <<"L", count::binary>>), do: {x - String.to_integer(count), y}
  defp next_position({x, y}, <<"U", count::binary>>), do: {x, y + String.to_integer(count)}
  defp next_position({x, y}, <<"D", count::binary>>), do: {x, y - String.to_integer(count)}

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
end

[nodes1, nodes2] =
  File.read!("day3/input")
  # File.read!("day3/input.test2")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(& String.split(&1, ","))
  |> Enum.map(&WireTracer.nodes/1)

node_pairs1 =
  nodes1
  |> Stream.chunk_every(2, 1, :discard)
  # |> Enum.to_list()
node_pairs2 =
  nodes2
  |> Stream.chunk_every(2, 1, :discard)
  # |> Enum.to_list()

intersections =
  Enum.flat_map(node_pairs1, fn (node_pair1) ->
    Enum.map(node_pairs2, fn (node_pair2) ->
      WireTracer.intersection(node_pair1, node_pair2)
    end)
  end)
  |> Enum.reject(&is_nil/1)
  |> Enum.map(fn {x, y} -> x + y end)
  |> IO.inspect()
  |> Enum.reject(& &1 == 0)
  |> Enum.min()
  |> IO.inspect()

