# Exit codes

> Exit codes are a number between 0 and 255, which is returned by any Unix command when it returns control to its parent process.
>
> - _Success_ is traditionally represented with exit `0`.
> - _Failure_ is normally indicated with a non-zero exit-code. This value can indicate different reasons for failure.

To display the last command's exit code:

```sh
echo $?
```
