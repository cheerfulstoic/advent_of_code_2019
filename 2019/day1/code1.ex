
File.read!("./day1/input")
|> String.split("\n")
|> Enum.reject(& &1 == "")
|> Enum.map(& Kernel.floor(String.to_integer(&1) / 3) - 2 )
|> Enum.sum()
|> IO.inspect()
