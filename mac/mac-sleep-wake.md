## macOS sleep and wake

The `pmset` command can be used to identify when macOS went to sleep or woke up:

```shell
pmset -g log | grep -e " Sleep  " -e " Wake  " -e " DarkWake  "
```

## Example

Get the most recent sleep or wake:

```shell
pmset -g log | grep -e " Sleep  " -e " Wake  " -e " DarkWake  " | tail -1
2020-09-23 08:46:04 +0100 Wake                	DarkWake to FullWake from Normal Sleep [CDNVA] due to Notification: Using AC (Charge:98%)
```
