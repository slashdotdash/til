# GenServer name registration using `:via`

The `:via` option expects a module that exports:

- `register_name/2`
- `unregister_name/1`
- `whereis_name/1`
- `send/2`

One such example is the :global module which uses these functions for keeping the list of names of processes and their associated PIDs that are available globally for a network of Elixir nodes. Elixir also ships with a local, decentralized and scalable registry called [Registry](https://hexdocs.pm/elixir/Registry.html) for locally storing names that are generated dynamically.
