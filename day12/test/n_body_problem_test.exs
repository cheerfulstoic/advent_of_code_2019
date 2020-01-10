defmodule NBodyProblemTest do
  use ExUnit.Case

  test "Works on example inputs" do
    input = """
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
    """

    bodies = NBodyProblem.parse_input(input)
    assert bodies == [
      {[-1, 0, 2], [0, 0, 0]},
      {[2, -10, -7], [0, 0, 0]},
      {[4, -8, 8], [0, 0, 0]},
      {[3, 5, -1], [0, 0, 0]}
    ]

    bodies = NBodyProblem.step_bodies(bodies)

    assert bodies == [
      {[2, -1, 1], [3, -1, -1]},
      {[3, -7, -4], [1, 3, 3]},
      {[1, -7, 5], [-3, 1, -3]},
      {[2, 2, 0], [-1, -3, 1]}
    ]

    bodies = NBodyProblem.step_bodies(bodies)

    assert bodies == [
      {[5, -3, -1], [3, -2, -2]},
      {[1, -2, 2], [-2, 5, 6]},
      {[1, -4, -1], [0, 3, -6]},
      {[1, -4, 2], [-1, -6, 2]}
    ]

    # Example for after 10 steps
    bodies = [
      {[2,  1, -3], [-3, -2,  1]},
      {[1, -8,  0], [-1,  1,  3]},
      {[3, -6,  1], [ 3,  2, -3]},
      {[2,  0,  4], [ 1, -1, -1]}
    ]

    assert NBodyProblem.total_energy(bodies) == 179
  end
end
