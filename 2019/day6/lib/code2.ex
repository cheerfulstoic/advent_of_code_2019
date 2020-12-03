Code.require_file("./lib/orbits.ex")

orbit_definitions =
  File.read!("input")
  |> String.split("\n")
  |> Enum.reject(& &1 == "")
  |> Enum.map(fn string -> String.split(string, ")") end)

my_chain =
Orbits.orbital_chain(orbit_definitions, "YOU")

santas_chain =
Orbits.orbital_chain(orbit_definitions, "SAN")

closest_transfer =
  my_chain
  |> Enum.find(fn (body) -> Enum.member?(santas_chain, body) end)
  |> IO.inspect(label: :closest_transfer)

my_index = Enum.find_index(my_chain, & &1 == closest_transfer)
santas_index = Enum.find_index(santas_chain, & &1 == closest_transfer)

IO.inspect(my_index + santas_index)


# 510 is too low
