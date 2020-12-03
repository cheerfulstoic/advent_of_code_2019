defmodule NBodyProblem do
  def parse_input(input_string) do
    input_string
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn (line) ->
      coords =
        Regex.scan(~r/-?\d+/, line)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)

      {coords, [0, 0, 0]}
    end)
  end

  @spec step_bodies(list(body())) :: list(body())
  def step_bodies(bodies) do
    bodies
    |> Stream.with_index()
    |> Enum.map(fn {body, index} ->
      bodies
      |> List.delete_at(index)
      |> Enum.reduce(body, fn (other_body, body) ->
        NBodyProblem.step_gravity_by(body, other_body)
      end)
      |> NBodyProblem.step_velocity()
    end)
  end

  @type body :: {list(integer), list(integer)}
  @spec step_gravity_by(body(), body()) :: body()
  def step_gravity_by({position, velocity}, {other_position, _}) do
    new_velocity =
      Stream.zip([position, other_position, velocity])
      |> Enum.map(fn {pos_cord, other_pos_coord, velocity_coord} ->
        cond do
          pos_cord == other_pos_coord -> velocity_coord
          pos_cord < other_pos_coord -> velocity_coord + 1
          true -> velocity_coord - 1
        end
      end)

    {position, new_velocity}
  end

  def step_velocity({position, velocity}) do
    new_position =
      Enum.zip(position, velocity)
      |> Enum.map(fn {pos_cord, velocity_cord} -> pos_cord + velocity_cord end)

    {new_position, velocity}
  end

  def total_energy(bodies) do
    Enum.map(bodies, fn ({position, velocity}) ->
      sum_of_abs(position) * sum_of_abs(velocity)
    end)
    |> Enum.sum()
  end

  def sum_of_abs(list) do
    list
    |> Enum.map(&abs/1)
    |> Enum.sum()
  end
end

