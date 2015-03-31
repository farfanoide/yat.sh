- [ ] check for tmux version and change set-path to -c accordingly get tmux version pre 1.8 => tmux server-info | sed -ne '1p'

# idea: group allows to create groups of sessions
#                   --rename oldgroupname newgroupname => self explanatory
#                   --move session[s] newgroup => move session[s] from one group to another
# options would be: --new groupname  => create new group

- [ ] fix errors:
    new_session:cd:2: no such file or directory: /usr/local/bin /usr/local/sbin /usr/sbin /usr/bin /sbin /bin /usr/games /usr/local/games
    set option: default-path -> "/usr/local/bin /usr/local/sbin /usr/sbin /usr/bin /sbin /bin /usr/games /usr/local/games"
    tmux 1.8

- [ ] unify usage() function
