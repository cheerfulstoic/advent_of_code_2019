Code.require_file("./lib/n_body_one_dimension_problem.ex")

previous_states = Map.new

input = File.read!("./input")

sample_input = """
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
"""

dimensions = NBodyOneDimensionProblem.parse_input(input)
# dimensions = NBodyOneDimensionProblem.parse_input(sample_input)


dimensions
|> Enum.map(fn (dimension) ->
  NBodyOneDimensionProblem.first_duplicate_step(dimension)
end)
|> IO.inspect()
