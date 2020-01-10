defmodule Orbits do
  def unique_bodies(orbit_definitions) do
    Enum.flat_map(orbit_definitions, & &1) |> Enum.uniq()
  end

  def total_orbit_count(orbit_definitions, body) do
    case Enum.find(orbit_definitions, fn [_, orbiter] -> body == orbiter end) do
      [orbitee, body] -> total_orbit_count(orbit_definitions, orbitee) + 1
      _ -> 0
    end
  end

  def orbital_chain(orbit_definitions, body, so_far \\ []) do
    case Enum.find(orbit_definitions, fn [_, orbiter] -> body == orbiter end) do
      [orbitee, body] -> [orbitee | orbital_chain(orbit_definitions, orbitee, so_far)]
      _ -> []
    end
  end
end

