# GraveNewWorldMain
Repository for desktop/laptops and such devices

Has source code as submodule

## Update code from remote
`git pull --recurse-submodules`

## Push changes
Commit submodules changes separately, commit at parent project level, then do `git push --recurse-submodules=on-demand` on this project root to publish changes and update reference commits for submodules.
