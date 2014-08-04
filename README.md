# yat.sh (Yet another Tmux session handler)

`Yat.sh` is an attempt at making tmux session management easy and portable, it
was once based on Trey Hunner's tmuxstart[1], but has been rethought (and
        rewritten) for my own requirements, with some consideration put into
portability and extensibility.

![Screenshot](http://cl.ly/image/0S2l1J1n2v23/yatsh.gif)
## Disclaimer
    This is very much alpha software!

## Diffrences with other options:

Yat.sh is basically a set of shell scripts
meaning the only dependency for it to work is tmux itself.

You don't need ruby or any gem, just install it into your path and you're good
to go.

Yat.sh introduces some concepts that need to be explained, like session types.
Alternatives like tmuxinator[2] and teamocil[3] only let you have sessions in
one directory, which is great when you have a reduced number of sessions, but
as you work on new projects your list rapidly grows, however, for the most
part, you're only gonna use a few of those sessions at a time.

Yat.sh tries to solve this problem by allowing you to have different types of
sessions, which will be explained next.

## Sessions and session types:

Sessions:
---------
`Sessions` are, for all intents and purposes of our project, nothing more than
scripts with certain commands to startup a tmux session and set it up.

The simplest example could be something like:

```bash
new_session -n 'General'

send_line 'General' 'ls'
```

This session file would create a tmux session containing a window named
'General' and it'd execute ls on it. More examples can be found in the examples
folder.

Session types:
--------------

Out of the box Yat.sh has support for 3 types of sessions: "Local", "Global", "Remote".

    Local Sessions:

    These care about the directory from which they're invoked, all their commands
    are relative to it. This might seem irrelevant, but in fact it gives us a lot
    of flexibility.  We can now share a complete tmux session with our project, or
    simply save it under version control and use it whenever we want to work back
    on it, without having it clutter our sessions list every day.

    Global Sessions:

    Globals are... 'just sessions' in the sense that we're
    accustomed with tmuxinator.  A global session would, for example `cd` into some
    directory before executing some command.

    Remote Sessions:

    Why can't we manage tmux sessions in our servers the same way we do on our own
    computers?. Yat.sh gives us the ability to startup and attach to tmux sessions
    running on other hosts in a simple and transparent way.
    Currently remote connections are done via ssh, but mosh support is on the way.

## Installation:
Download this repo and make sure `bin/yat.sh` is in your $PATH

1. Download the repo into `~/.yat.sh`.

```bash
    $ git clone https://github.com/farfanoide/yat.sh ~/.yat.sh
```

2. Add `~/.yat.sh/bin` to your `$PATH`.  You can do it by adding the next line
into your shell config file (for zsh it would be ~/.zshr, for bash ~/.bashrc
        or ~/.bash_profile)

```bash
    export PATH="$HOME/.yat.sh/bin:$PATH"'
```

- [ ] TODO
## Creating session files:
- [ ] TODO
## Usage:
- [ ] TODO
## Completions:
- [ ] TODO
## Test:
- [ ] TODO
## Contributions:


[1]:https://github.com/treyhunner/tmuxstart
[2]:https://github.com/tmuxinator/tmuxinator
[3]:https://github.com/remiprev/teamocil
