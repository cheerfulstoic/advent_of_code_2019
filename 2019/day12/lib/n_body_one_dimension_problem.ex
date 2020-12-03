defmodule NBodyOneDimensionProblem do
  def parse_input(input_string) do
    raw_values =
      input_string
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn (line) ->
        coords =
          Regex.scan(~r/-?\d+/, line)
          |> List.flatten()
          |> Enum.map(&String.to_integer/1)

        coords
      end)

    Enum.map(0..length(List.first(raw_values)) - 1, fn (i) ->
      {Enum.map(raw_values, & Enum.at(&1, i)), [0, 0, 0, 0]}
    end)
  end

  def step_dimensions(dimensions) do
    dimensions
    |> Enum.map(&step_gravity/1)
    |> Enum.map(&step_velocity/1)
  end

  def first_duplicate_step(dimension, dimensions_so_far \\ MapSet.new()) do
    if MapSet.member?(dimensions_so_far, dimension) do
      MapSet.size(dimensions_so_far)
    else
      new_dimension =
        dimension
        |> step_gravity()
        |> step_velocity()
      first_duplicate_step(new_dimension, MapSet.put(dimensions_so_far, dimension))
    end
  end

  def step_gravity({pos_coords, vel_coords}) do
    new_vel_coords =
      Stream.zip(pos_coords, vel_coords)
      |> Enum.map(fn {pos_coord, vel_coord} ->
        Enum.reduce(pos_coords, vel_coord, fn (other_pos_coord, new_vel_coord) ->
          cond do
            pos_coord == other_pos_coord -> new_vel_coord
            pos_coord < other_pos_coord -> new_vel_coord + 1
            true -> new_vel_coord - 1
          end
        end)
      end)

    {pos_coords, new_vel_coords}
  end

  def step_velocity({pos_coords, vel_coords}) do
    new_pos_coords =
      Stream.zip(pos_coords, vel_coords)
      |> Enum.map(fn {pos_coord, vel_coord} -> pos_coord + vel_coord end)

    {new_pos_coords, vel_coords}
  end
end
