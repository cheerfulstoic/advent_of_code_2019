defmodule Fuel do
  def amount_needed_for(value) do
    initial_amount = Kernel.floor(value / 3) - 2
    cond do
      initial_amount <= 0 -> 0
      true -> initial_amount + amount_needed_for(initial_amount)
    end
  end
end

IO.inspect(Fuel.amount_needed_for(100756), label: :test)

File.read!("./day1/input")
|> String.split("\n")
|> Enum.reject(& &1 == "")
|> Enum.map(& Fuel.amount_needed_for(String.to_integer(&1)) )
|> Enum.sum()
|> IO.inspect()

