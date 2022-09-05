# Erlang version

```shell
erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), io:fwrit
e(Version), halt().' -noshell
```

### Example

```shell
$ erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), io:fwrit
e(Version), halt().' -noshell
24.3.4.2
```

### Reference

* [How to get Erlang's release version number from a shell?](https://stackoverflow.com/questions/9560815/how-to-get-erlangs-release-version-number-from-a-shell)
