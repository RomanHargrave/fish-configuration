#!/usr/bin/env fish

# GIT_DIR isn't absolutized or reliable IME
set repo_base (dirname (git rev-parse --git-dir))
set management_scripts $repo_base/.management

echo "GIT: Running Generic Post Hook"
fish $management_scripts/update.fish
