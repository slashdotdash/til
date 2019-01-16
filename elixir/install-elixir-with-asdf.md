# Install Elixir and Erlang with `asdf` version manager

1. Install [asdf](https://github.com/asdf-vm/asdf).

2. Install plugins

  ```sh
  asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
  asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
  ```

3. Install Erlang:

  ```sh
  asdf install erlang 21.2.3
  asdf global erlang 21.2.3
  ```

4. Install Elixir:

  ```sh
  asdf install elixir 1.8.0-otp-21
  asdf global elixir 1.8.0-otp-21
  ```
