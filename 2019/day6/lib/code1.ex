Code.require_file("./lib/orbits.ex")

orbit_definitions =
  File.read!("input")
  |> String.split("\n")
  |> Enum.reject(& &1 == "")
  |> Enum.map(fn string -> String.split(string, ")") end)

bodies = Orbits.unique_bodies(orbit_definitions)
         |> IO.inspect(label: :bodies)

bodies
|> Enum.map(fn (body) -> Orbits.total_orbit_count(orbit_definitions, body) end)
|> IO.inspect(label: :orbit_counts)
|> Enum.sum()
|> IO.inspect(label: :sum)
