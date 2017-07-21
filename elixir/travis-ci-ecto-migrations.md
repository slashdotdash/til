# Travis CI Ecto migrations

To run unit tests on [Travis CI](https://travis-ci.org/) using Ecto and PostgreSQL you must:

1. Include the `postgresql` service and add-on.
2. Run `mix ecto.create` and `mix ecto.migrate` as a `before_script`.

Here's an example `travis.yml` config file:

```yaml
language: elixir

elixir:
  - 1.4.5

otp_release:
  - 20.0

services:
  - postgresql

before_script:
  - MIX_ENV=test mix do ecto.create, ecto.migrate

sudo: required
dist: trusty

addons:
  postgresql: "9.6"
```
