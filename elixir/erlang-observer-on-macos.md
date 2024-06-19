# Running Erlang's observer on macOS

Install `wxwidgets` with Homebrew:

```shell
brew install wxwidgets
```

Find the location of `wx-config`:

```shell
$ which wx-config
/opt/homebrew/bin/wx-config
```

Enable wx via `KERL_CONFIGURE_OPTIONS`:

```shell
export KERL_CONFIGURE_OPTIONS="--enable-wx --with-wx-config=/opt/homebrew/bin/wx-config"
```

Install Erlang with asdf _after_ wxwidgets has been installed:

```shell
asdf install erlang <version>
```

Note if you already have the specific version of Erlang installed you wil need to remove and then reinstall it.

```shell
asdf uninstall erlang <version>
asdf install erlang <version>
```

Run observer via `iex` shell:

```shell
iex> :observer.start()
```