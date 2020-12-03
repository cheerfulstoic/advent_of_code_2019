defmodule FuelCalculator do
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, fn (line, result) ->
      [requirements, product] =
        line
        |> String.trim()
        |> String.split(" => ")

      requirements = parse_parts(requirements)
      [{product_amount, product_chemical}] = parse_parts(product)

      Map.put(result, product_chemical, {product_amount, requirements})
    end)
  end

  def amounts_required(data, target_chemical, amount_needed) do
    case Map.get(data, target_chemical) do
      {product_amount, requirements} ->
        reactions_required = Float.ceil(amount_needed / product_amount) |> trunc()

        Enum.flat_map(requirements, fn {required_amount, required_chemical} ->
          required_amount_needed = required_amount * reactions_required

          amounts_required(data, required_chemical, required_amount_needed) ++
            [{0, required_chemical, Integer.mod(amount_needed, product_amount)}]
        end)

      nil -> []
    end
    |> Enum.group_by(fn {_, chemical, _} -> chemical end)
    |> Enum.map(fn {chemical, list} ->
      {Enum.map(list, fn {a, _, _} -> a end) |> Enum.sum(),
        chemical,
        Enum.map(list, fn {_, _, l} -> l end) |> Enum.sum()}
    end)
    |> IO.inspect(label: :level)
  end

  defp parse_parts(string) do
    string
    |> String.split(", ")
    |> Enum.map(& String.split(&1, " "))
    |> Enum.map(fn [count, chemical] ->
      {String.to_integer(count), chemical}
    end)
  end
end

