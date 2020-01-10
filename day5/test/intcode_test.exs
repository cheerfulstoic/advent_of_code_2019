defmodule IntcodeTest do
  use ExUnit.Case
  doctest Intcode

  test "Work on day2 main example program" do
    memory = [1,9,10,3,2,3,11,0,99,30,40,50]
    assert Intcode.process_memory(memory) == [3500,9,10,70,2,3,11,0,99,30,40,50]
  end

  test "Work on day2 small example programs" do
    memory = [1,0,0,0,99]
    assert Intcode.process_memory(memory) == [2,0,0,0,99]

    memory = [2,3,0,3,99]
    assert Intcode.process_memory(memory) == [2,3,0,6,99]

    memory = [2,4,4,5,99,0]
    assert Intcode.process_memory(memory) == [2,4,4,5,99,9801]

    memory = [1,1,1,4,99,5,6,0,99]
    assert Intcode.process_memory(memory) == [30,1,1,4,2,5,6,0,99]
  end

  test "Works on day5 small example program" do
    memory = [1002,4,3,4,33]
    assert Intcode.process_memory(memory) == [1002,4,3,4,99]
  end
end
