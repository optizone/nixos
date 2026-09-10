# Shells

Per-project (or group of projects) shells. Used when project does not use its
own nix shell.

Shared flake.lock is used to minimize shells size.

> [!WARNING]
> Be careful about your inputs if using shared lock file. Inputs with the same
> name shoud have the same url.

## Usage

1. Hardlink (symlinks won't work) `flake.lock` and `flake.nix` (rename the shell
   of your choosing) to project directory.
2. Run `echo 'use flake path:.' > .envrc` (relevant only for `direnv` users)
3. Add `flake.nix` and `flake.lock` to your `.git/info/exclude`
