# Use monotonic time for timing

You should use Erlang's [monotonic_time](http://erlang.org/doc/man/erlang.html#monotonic_time-0) for timing since it is not affected by OS clock changes.

This is [used internally](http://erlang.org/doc/apps/erts/time_correction.html#Erlang_Monotonic_Time) as the "time engine" for almost all Erlang's time based processing.

 > `System.monotonic_time/1`

 > Returns the current monotonic time in the given time unit.

 > This time is monotonically increasing and starts in an unspecified point in time.

```elixir
start_time = System.monotonic_time(:microseconds)

# ... do something you want to be timed

end_time = System.monotonic_time(:microseconds)

duration_in_microseconds = end_time - start_time
```
