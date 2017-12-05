# Increase open file limit

By default, the maximum number of files that macOS can open is set to 12,288:

```console
$ sysctl kern.maxfiles
kern.maxfiles: 12288
```

The maximum number of files a given process can open is 10,240:

```console
$ sysctl kern.maxfilesperproc
kern.maxfilesperproc: 10240
```

Increase limits:

```console
$ sudo launchctl limit maxfiles 1000000 1000000
```

Note the increased limits will reset to the defaults after a reboot.

## References

- [Increase the maximum number of open file descriptors in Snow Leopard?](https://superuser.com/questions/302754/increase-the-maximum-number-of-open-file-descriptors-in-snow-leopard)
- [Maximum Files in Mac OS X](http://krypted.com/mac-os-x/maximum-files-in-mac-os-x/)
