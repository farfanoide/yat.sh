# yat.sh
    (Yet another Tmux session handler)

`Yat.sh` is an attempt at making tmux session management easy and portable, it
was once based on Trey Hunner's [tmuxstart][1], but has been rethought (and
rewritten) for my own requirements, with portability and extensibility as main
goals.

![Screenshot](http://cl.ly/image/0S2l1J1n2v23/yatsh.gif)

## Disclaimer
    Still at alpha stages, it shouldn't eat your kittens... but i can't promise anything.


## Diffrences with other options:

Yat.sh is basically a set of shell scripts meaning the only dependency for it
to work is tmux itself. You don't need ruby or any gem, just install it into
your path and you're good to go.

Traditionally, alternatives like [tmuxinator][2] and [teamocil][3] only let you
have session files in one directory, which is great when you have a reduced
number of them, but as you work on new projects your list rapidly grows,
however, for the most part, you're only gonna use a few of those sessions at a
time.

Yat.sh tries to solve this problem by allowing you to have different types of
sessions, which we will explain shortly.

Sessions:
---------
`Sessions` are, for all intents and purposes of our project, nothing more than
scripts with certain commands to create a tmux session and set it up.

The simplest example could be something like:

```bash
new_session -n 'General'

send_line 'General' 'ls'
```

This session file would create a tmux session containing a window named
'General' and it would execute `ls` on it. More examples can be found in the examples
folder.

Session types:
--------------

Out of the box Yat.sh has support for 3 types of sessions: "Portable", "Global" and "Remote".

    Portable Sessions:

    These care about the directory from which they're invoked, since all their
    commands are relative to it. This might seem irrelevant, but in fact it
    gives us a lot of flexibility.  We can now share a complete tmux session
    with our project, or simply save it under version control and use it
    whenever we want to work back on it, without having it cluttering our
    sessions list every day.

    Global Sessions:

    Globals are... 'just sessions' in the sense that we're accustomed with
    tmuxinator.  A global session would, for example `cd` into some directory
    before executing a command.

    Remote Sessions:

    Why can't we manage tmux sessions in our servers the same way we do on our
    own computers?. Yat.sh gives us the ability to startup and attach to tmux
    sessions running on other hosts in a simple and transparent way.  Currently
    remote connections are done via ssh, but mosh support is on the way.

## Installation:
Download this repo and make sure `bin/yat.sh` is in your $PATH

1. Download the repo into `~/.yat.sh`.

```bash
    $ git clone https://github.com/farfanoide/yat.sh ~/.yat.sh
```

2. Add `~/.yat.sh/bin` to your `$PATH`.  You can do it by adding the next line
   into your shell config file (for zsh it would be ~/.zshr, for bash ~/.bashrc
   or ~/.bash_profile).

```bash
    export PATH="$HOME/.yat.sh/bin:$PATH"
```
If you just want to quickly test it, an alias would also work.


## Usage:

Yat.sh itself is just a dispatcher, this means all functionality is based on
subcommands or plugins. The first argument received by yat.sh will try to be
executed, if no such command is found, the `load` command will treat it as a
session name.

### Commands:

#### Delete
Delete a session file if exists.

```bash
   $ yat.sh delete main
```

#### Example
List available example session files with a short description if available.
Descriptions can be added via custom data attributes.

```bash
    $ yat.sh example
```

#### Help
Print usage for yat.sh itself or any other sucommand

```bash
    $ yat.sh help new
```

#### Link
Link local session file to global directory making it available from anywhere.

```bash
    $ yat.sh link session_file
```
#### List
List available session files and optionally other running sessions. (alias = ls)

```bash
    $ yat.sh list
```

#### Load
Start and setup a tmux session from a session file or attach to one already
running. If no session file is found an empty tmux session will be created and
attached to.

```bash
    $ yat.sh load session_file
```

#### New
Create a session file optionally from a predefined example. If `-l` flag is
given, the new file will be saved under the current directory oppsed to default
behaviour which would be to save it under `$YATSH_SESSIONS_DIR`

```bash
    $ yat.sh new session_name -e example_name
```

#### Open
Open a session file for editing with your `$EDITOR`

```bash
    $ yat.sh open session_file
```

#### Remote

Similar to `load` except on remote servers. `yat.sh remote` loads regular
session files but parses some custom data attributes, namely server and remote
session name. An `ssh` connection will try to be established to said server,
from then on, everything works just like with `yat.sh load` but on the remote server.

Example remote session:
($YATSH_SESSIONS_DIR/remote_session)
```bash

#= SERVER: root@myserver

#= NAME: remote_session_name

new_session -n 'General'

send_line 'General' 'ls'
```

```
    $ yat.sh remote remote_session
```

In the previous example we are creating a session named 'remote_session_name'
on 'myserver' as the user 'root'. Note that connections are done via ssh which
means that you can use aliases from your `~/.ssh/config`

#### Version
Print yat.sh version number.

## Custom Data Attributes:

This is a simple way of entering extra information in session files which will
not be executed unless specifically parsed and used by a command. Basically
these data attributes are bash comments that follow a simple pattern:

```bash
#= KEY: everything after the semicolon is used as value
```

- [ ] TODO ## Creating session files:
- [ ] TODO ## Usage:
- [ ] TODO ## Completions:
- [ ] TODO ## Plugins:
- [ ] TODO ## Test:
- [ ] TODO
- [ ] TODO ## Contributions:


[1]:https://github.com/treyhunner/tmuxstart
[2]:https://github.com/tmuxinator/tmuxinator
[3]:https://github.com/remiprev/teamocil
