defmodule IntcodeTest do
  use ExUnit.Case

  test "Work on day2 main example program" do
    memory = Intcode.list_to_memory([1,9,10,3,2,3,11,0,99,30,40,50])
    assert Intcode.process_memory(memory, []) == Intcode.list_to_memory([3500,9,10,70,2,3,11,0,99,30,40,50])
  end

  test "Work on day2 small example programs" do
    memory = Intcode.list_to_memory([1,0,0,0,99])
    assert Intcode.process_memory(memory, []) == Intcode.list_to_memory([2,0,0,0,99])

    memory = Intcode.list_to_memory([2,3,0,3,99])
    assert Intcode.process_memory(memory, []) == Intcode.list_to_memory([2,3,0,6,99])

    memory = Intcode.list_to_memory([2,4,4,5,99,0])
    assert Intcode.process_memory(memory, []) == Intcode.list_to_memory([2,4,4,5,99,9801])

    memory = Intcode.list_to_memory([1,1,1,4,99,5,6,0,99])
    assert Intcode.process_memory(memory, []) == Intcode.list_to_memory([30,1,1,4,2,5,6,0,99])
  end

  test "Works on day5 small example program" do
    memory = Intcode.list_to_memory([1002,4,3,4,33])
    assert Intcode.process_memory(memory, []) == Intcode.list_to_memory([1002,4,3,4,99])
  end

  test "Works on day9 small example programs" do
    memory_list = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    memory = Intcode.list_to_memory(memory_list)
    Intcode.process_memory(memory, [self()])

    assert Intcode.receive_outputs() == memory_list



    memory_list = [1102,34915192,34915192,7,4,7,99,0]
    memory = Intcode.list_to_memory(memory_list)
    Intcode.process_memory(memory, [self()])

    values = Intcode.receive_outputs()
    assert [1219070632396864] == values



    memory_list = [104,1125899906842624,99]
    memory = Intcode.list_to_memory(memory_list)
    Intcode.process_memory(memory, [self()])

    values = Intcode.receive_outputs()
    assert [1125899906842624] == values
  end
end
