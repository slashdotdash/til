# Process links

```elixir
p1 =
  spawn(fn ->
    receive do
      :exit -> exit(:exit)
    end
  end)

p2 =
  spawn(fn ->
    true = Process.link(p1)

    receive do
      :exit -> exit(:exit)
    end
  end)

p1_ref = Process.monitor(p1)
p2_ref = Process.monitor(p2)

send(p2, :exit)

assert_receive {:DOWN, ^p1_ref, :process, _pid, _reason}
assert_receive {:DOWN, ^p2_ref, :process, _pid, _reason}
```
