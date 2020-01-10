defmodule NBodyProblemTest do
  use ExUnit.Case

  test "Works on example inputs" do
    input = """
    10 ORE => 10 A
    1 ORE => 1 B
    7 A, 1 B => 1 C
    7 A, 1 C => 1 D
    7 A, 1 D => 1 E
    7 A, 1 E => 1 FUEL
    """

    data = FuelCalculator.parse(input)
    assert data == %{
      "A" => {10, [{10, "ORE"}]},
      "B" => {1, [{1, "ORE"}]},
      "C" => {1, [{7, "A"}, {1, "B"}]},
      "D" => {1, [{7, "A"}, {1, "C"}]},
      "E" => {1, [{7, "A"}, {1, "D"}]},
      "FUEL" => {1, [{7, "A"}, {1, "E"}]},
    }

    assert FuelCalculator.amounts_required(data, "FUEL", 1) == [{31, "ORE", 2}]
    raise "Foo"


    input = """
      9 ORE => 2 A
      8 ORE => 3 B
      7 ORE => 5 C
      3 A, 4 B => 1 AB
      5 B, 7 C => 1 BC
      4 C, 1 A => 1 CA
      2 AB, 3 BC, 4 CA => 1 FUEL
    """

    data = FuelCalculator.parse(input)
    assert FuelCalculator.amounts_required(data, "FUEL", 1) == [{158, "ORE", 7}]
  end

  test "Works on simple inputs" do
    input = """
    10 ORE => 10 A
    """

    data = FuelCalculator.parse(input)
    assert FuelCalculator.amounts_required(data, "ORE", 1) == [{1, "ORE", 0}]
    assert FuelCalculator.amounts_required(data, "ORE", 3) == [{3, "ORE", 0}]

    data = FuelCalculator.parse(input)
    assert FuelCalculator.amounts_required(data, "A", 1) == [{1, "ORE", 9}]
    assert FuelCalculator.amounts_required(data, "A", 3) == [{1, "ORE", 7}]
    assert FuelCalculator.amounts_required(data, "A", 9) == [{10, "ORE", 1}]
    assert FuelCalculator.amounts_required(data, "A", 10) == [{10, "ORE", 0}]

  end
end
