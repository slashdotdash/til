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
