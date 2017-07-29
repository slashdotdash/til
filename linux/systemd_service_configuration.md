# systemd service configuration

[systemd](https://github.com/systemd/systemd) is an init system used in Linux distributions, such as Ubuntu, to to bootstrap the user space.

List available services:

```console
$ ls /lib/systemd/system/
```

Show system status:

```console
$ systemctl status
```

### Create a new service

Create the `foo` service config file in `/lib/systemd/system/foo.service`:

```
[Unit]
Description=Job that runs the foo daemon
Documentation=man:foo(1)

[Service]
Type=forking
Environment=statedir=/var/cache/foo
ExecStartPre=/usr/bin/mkdir -p ${statedir}
ExecStart=/usr/bin/foo-daemon --arg1 "hello world" --statedir ${statedir}

[Install]
WantedBy=multi-user.target
```

Reload the systemd daemon:

```console
$ sudo systemctl daemon-reload
```

Control the service (enable/start/stop/restart):

```console
$ sudo systemctl enable foo
$ sudo systemctl start foo
$ sudo systemctl restart foo
$ sudo systemctl stop foo
$ sudo systemctl status foo
```

#### Reference

- [SystemdForUpstartUsers](https://wiki.ubuntu.com/SystemdForUpstartUsers)
