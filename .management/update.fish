#!/usr/bin/env fish

set __self (dirname (realpath (status -f)))
source $__self/_tools.fish

update_submodules
insure_git_hooks
update_fisher
