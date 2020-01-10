Code.require_file("./lib/n_body_problem.ex")

bodies =
  File.read!("./input")
  |> NBodyProblem.parse_input()

final_bodies =
  Enum.reduce(1..1000, bodies, fn (_, bodies) ->
    IO.puts("-")
    NBodyProblem.step_bodies(bodies)
  end)

NBodyProblem.total_energy(final_bodies)
|> IO.inspect(label: :total_energy)
