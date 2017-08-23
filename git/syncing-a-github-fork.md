# Syncing a GitHub fork

Sync a fork of a repository to keep it up-to-date with the upstream repository.

List tracked repositories to identify name of the upstream remote:

```console
$ git remote show
upstream
origin
```

By default, GitHub will name the upstream remote after the forked repository's owner.

Fetch upstream repository:

```console
$ git fetch upstream
```

Rebase upstream changes into local branch:

```console
$ git checkout master
$ git rebase upstream/master
```
