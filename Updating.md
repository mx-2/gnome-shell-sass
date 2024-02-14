# Updating to latest upstream

Inside the gnome-shell repo run
```
(
    LAST=10bbebad14d1c38b45cb43c05f066641cd62961c
    i=1;
    for commit in $(
            git log --oneline $LAST..main -- data/theme/gnome-shell-sass |
            awk '{print $1}' |
            tac
    ); do
        git format-patch --relative=data/theme/gnome-shell-sass --start-number $i $commit^..$commit;
        i=$((i+1));
    done
)
```
to get all commits that changed the upstream gnome-shell theme as patch files.

Then use `git am *.patch` in this repo to apply those patches.
