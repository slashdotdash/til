# Remove unused dependencies from `mix.lock`

Run this command to remove unused dependencies from both `/deps` folder and the `mix.lock` file:

```shell
mix deps.clean --unlock --unused
```
