defmodule AsteroidsTest do
  use ExUnit.Case

  test "Works on example inputs" do
    positions =
      Astroids.positions("""
        .#..#
        .....
        #####
        ....#
        ...##
      """)

    position_viewable_counts =
      Astroids.position_viewable_counts(positions)

    assert positions == [{1, 0}, {4, 0}, {0, 2}, {1, 2}, {2, 2}, {3, 2}, {4, 2}, {4, 3}, {3, 4}, {4, 4}]

    assert position_viewable_counts == [
        {{1, 0}, 7},
        {{4, 0}, 7},
        {{0, 2}, 6},
        {{1, 2}, 7},
        {{2, 2}, 7},
        {{3, 2}, 7},
        {{4, 2}, 5},
        {{4, 3}, 7},
        {{3, 4}, 8},
        {{4, 4}, 7}
    ]

    positions =
      Astroids.positions("""
        ......#.#.
        #..#.#....
        ..#######.
        .#.#.###..
        .#..#.....
        ..#....#.#
        #..#....#.
        .##.#..###
        ##...#..#.
        .#....####
      """)


    {max_position, count} = 
      Astroids.position_viewable_counts(positions)
      |> Enum.max_by(fn {_, count} -> count end)

    assert max_position == {5, 8}
    assert count == 33
  end

  test ".occluded?" do
    assert Astroids.occluded?({3, 4}, {1, 0}, [{2, 2}]) == true
    assert Astroids.occluded?({3, 4}, {2, 2}, [{1, 0}]) == false

    assert Astroids.occluded?({3, 4}, {1, 0}, [{2, 3}]) == false

    assert Astroids.occluded?({1, 2}, {3, 2}, [{2, 2}]) == true
    assert Astroids.occluded?({1, 2}, {2, 2}, [{3, 2}]) == false
  end

  test ".without_point" do
    assert Astroids.without_point([], {1, 1}) == []

    assert Astroids.without_point([{1, 1}], {1, 1}) == []

    assert Astroids.without_point([{1, 1}], {1, 2}) == [{1, 1}]

    assert Astroids.without_point([{1, 1}, {2, 1}, {1, 2}, {2, 3}], {1, 2}) == [{1, 1}, {2, 1}, {2, 3}]
  end

  test ".lasering_order" do
    origin = {31, 20}

    positions =
      File.read!("./input")
      |> Astroids.positions()
      |> Astroids.without_point(origin)

    # first should be {31, 15} (vector {0, -5})

    positions
    |> Astroids.with_data(origin)
    |> Enum.sort_by(fn {_, params} -> params end)
    |> Astroids.lasering_order()
    |> IO.inspect(limit: :infinity)
    |> Enum.at(199)
    |> IO.inspect()
  end

  test ".angle_from_north" do
    assert Astroids.angle_from_north({1, 0}) == 1.5707963267948966
    assert Astroids.angle_from_north({0, 1}) == 3.141592653589793
    assert Astroids.angle_from_north({-1, 0}) == 4.71238898038469
  end
end


# 2608 is too high
# 3323 is too high
# 3933 is too high
