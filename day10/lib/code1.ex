defmodule Astroids do
  def positions(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(& String.codepoints(&1))
    |> Enum.map(& Enum.with_index(&1))
    |> Enum.with_index()
    |> Enum.flat_map(fn {spots, y} ->
      Enum.map(spots, fn
        {".", x} -> nil
        {"#", x} -> {x, y}
      end)
    end)
    |> Enum.reject(&is_nil/1)
  end

  def position_viewable_counts(positions) do
    Enum.map(positions, fn point1 ->
      search_positions = without_point(positions, point1)

      count =
        Enum.count(search_positions, fn point2 ->
          !occluded?(point1, point2, without_point(search_positions, point2))
        end)

      {point1, count}
    end)
  end

  def occluded?(position1, position2, positions) do
    Enum.any?(positions, fn check_position ->
      colinear?(position1, position2, check_position) &&
        between?(position1, position2, check_position)
    end)
  end

  def colinear?({x1, y1}, {x2, y2}, {x3, y3}) do
    (x1 * (y2 - y3)) +
    (x2 * (y3 - y1)) +
    (x3 * (y1 - y2)) == 0
  end

  def between?({x1, y1}, {x2, y2}, {test_x, test_y}) do
    {v1_x, v1_y} = {x1 - test_x, y1 - test_y}
    {v2_x, v2_y} = {x2 - test_x, y2 - test_y}

    (sign(v1_x) == 0 || sign(v2_x) == 0 ||sign(v1_x) != sign(v2_x)) &&
      (sign(v1_y) == 0 || sign(v2_y) == 0 ||sign(v1_y) != sign(v2_y))
  end

  def vector({x1, y1}, {x2, y2}) do
    {x2 - x1, y2 - y1}
  end

  def lasering_order(positions_with_data, bigger_than_angle \\ -1)

  def lasering_order([], _), do: []
  def lasering_order(positions_with_data, bigger_than_angle) do
    first =
      Enum.find(positions_with_data, fn {position, [angle_from_north, magnitude]} ->
        angle_from_north > bigger_than_angle
      end)

    if is_nil(first) do
      lasering_order(positions_with_data, -1)
    else
      {_, [angle, _]} = first
      [first | lasering_order(List.delete(positions_with_data, first), angle)]
    end
  end

  def with_data(positions, origin) do
    Enum.map(positions, fn position ->
      vector = vector(origin, position)

      {position, [angle_from_north(vector), magnitude(vector)]}
    end)
  end

  # North vector: {0, -1}
  @half_pi :math.pi() / 2
  @two_pi :math.pi() * 2
  def angle_from_north({v_x, v_y}) do
    # Adjust by (pi / 2) to get angle from north
    value = :math.atan2(v_y, v_x) + @half_pi

    cond do
      value < 0 -> @two_pi + value
      value > @two_pi -> value - @two_pi
      true -> value
    end
  end

  # def angle_from_north({v_x, v_y}) do
  #   dot_product = (v_x * 0) + (v_y * -1)
  #
  #   :math.acos(dot_product / (magnitude({v_x, v_y}) * magnitude({0, 1})))
  # end

  def magnitude({vec_x, vec_y}) do
    :math.sqrt(:math.pow(vec_x, 2) + :math.pow(vec_y, 2))
  end

  def distance({x1, y1}, {x2, y2}) do
    :math.sqrt(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2))
  end

  # Returns 1 for positive
  # Returns -1 for negative
  # Fails for 0 (works for this module specifically)
  def sign(int) do
    cond do
      int > 0 -> 1
      int < 0 -> -1
      true -> 0
    end
  end

  def without_point([], _), do: []
  def without_point([first | rest], first), do: without_point(rest, first)
  def without_point([first | rest], point), do: [first | without_point(rest, point)]
end

