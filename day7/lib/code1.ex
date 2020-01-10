memory =
  File.read!("./input")
  |> String.split(",")
  |> Enum.reject(& &1 == "")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.to_integer/1)

Code.require_file("./lib/intcode.ex")

main_pid = self()

phase_settings = [3, 1, 2, 4, 0]

{:ok, intcode_agent} = Intcode.start_link(main_pid)

max = 4
phase_setting_combinations =
  for a <- 0..max, b <- 0..max, c <- 0..max, d <- 0..max, e <- 0..max, do: [a, b, c, d, e]

phase_setting_combinations =
  Enum.filter(phase_setting_combinations, & length(Enum.uniq(&1)) == 5)

final_outputs =
  Enum.map(phase_setting_combinations, fn (phase_settings) ->
    Enum.reduce(phase_settings, 0, fn (phase_setting, previous_output) ->
      task =
        Task.async(fn ->
          Intcode.process_memory(memory)
        end)

      send(task.pid, {:input, phase_setting})
      send(task.pid, {:input, previous_output})

      Task.await(task, :infinity)

      {:message_queue_len, length} = Process.info(self(), :message_queue_len)
      IO.inspect(length, label: :length)

      [output] =
        Enum.map((0..length-1), fn (_i) ->
          receive do
            {:output, output} -> output
          end
        end)

      IO.inspect(output, label: :output)

      output
    end)
  end)

max_final_output = Enum.max(final_outputs)
IO.inspect(max_final_output, label: :max_final_output)

Enum.zip(phase_setting_combinations, final_outputs)
|> Enum.filter(fn {_, final_output} -> final_output == max_final_output end)
|> IO.inspect(label: :result)

# 33333 is too low
# 248093 is too high
