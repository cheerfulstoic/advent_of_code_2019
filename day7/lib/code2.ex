memory =
  File.read!("./input")
  |> String.split(",")
  |> Enum.reject(& &1 == "")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.to_integer/1)

Code.require_file("./lib/intcode.ex")

main_pid = self()

phase_settings = [3, 1, 2, 4, 0]

min = 5
max = 9
phase_setting_combinations =
  for a <- min..max, b <- min..max, c <- min..max, d <- min..max, e <- min..max, do: [a, b, c, d, e]

phase_setting_combinations =
  Enum.filter(phase_setting_combinations, & length(Enum.uniq(&1)) == 5)

final_outputs =
  Enum.map(phase_setting_combinations, fn ([phase_a, phase_b, phase_c, phase_d, phase_e]) ->
    [amp_a, amp_b, amp_c, amp_d, amp_e] = tasks =
      Enum.map(1..5, fn (_i) ->
        Task.async(fn ->
          output_pids =
            receive do
              {:output_pids, output_pids} -> output_pids
            end
          Intcode.process_memory(memory, output_pids)
        end)
      end)

    send(amp_a.pid, {:output_pids, [amp_b.pid]})
    send(amp_a.pid, {:output, phase_a})

    send(amp_b.pid, {:output_pids, [amp_c.pid]})
    send(amp_b.pid, {:output, phase_b})

    send(amp_c.pid, {:output_pids, [amp_d.pid]})
    send(amp_c.pid, {:output, phase_c})

    send(amp_d.pid, {:output_pids, [amp_e.pid]})
    send(amp_d.pid, {:output, phase_d})

    send(amp_e.pid, {:output_pids, [amp_a.pid, self()]})
    send(amp_e.pid, {:output, phase_e})


    send(amp_a.pid, {:output, 0})

    for task <- tasks do
      Task.await(task, :infinity)
    end

    {:message_queue_len, length} = Process.info(self(), :message_queue_len)
    IO.inspect(length, label: :length)

    outputs =
      Enum.map((0..length-1), fn (_i) ->
        receive do
          {:output, output} -> output
        end
      end)

    IO.inspect(outputs, label: :outputs)

    List.last(outputs)
  end)

max_final_output = Enum.max(final_outputs)
IO.inspect(max_final_output, label: :max_final_output)

Enum.zip(phase_setting_combinations, final_outputs)
|> Enum.filter(fn {_, final_output} -> final_output == max_final_output end)
|> IO.inspect(label: :result)

# 33333 is too low
# 248093 is too high
