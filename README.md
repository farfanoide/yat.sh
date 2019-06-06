yat.sh
======

    (Yet another Tmux session handler)

`Yat.sh` is an attempt at making [tmux][tmux] session management easy and
portable, it was once based on Trey Hunner's [tmuxstart][tmuxstart], but has
been rethought (and rewritten) for my own requirements, with portability and
extensibility as main goals.

![Screenshot](http://cl.ly/image/0S2l1J1n2v23/yatsh.gif)

Disclaimer
----------

    Still at alpha stages, it shouldn't eat your kittens... but i can't promise anything.


Diffrences with other options:
------------------------------

Yat.sh is basically a set of shell scripts meaning the only dependency for it
to work is tmux itself. You don't need ruby or any gem, just install it into
your path and you're good to go.

Traditionally, alternatives like [tmuxinator][tmuxinator] and
[teamocil][teamocil] only let you have session files in one directory, which is
great when you have a reduced number of them, but as you work on new projects
your list rapidly grows, however, for the most part, you're only gonna use a
few of those sessions at a time.

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
'General' and it would execute `ls` on it. More examples can be found in the
examples folder.

Session types:
--------------

Out of the box Yat.sh has support for 3 types of sessions: "Portable", "Global"
and "Remote".

### Portable Sessions:

    These care about the directory from which they're invoked, since all their
    commands are relative to it. This might seem irrelevant, but in fact it
    gives us a lot of flexibility.  We can now share a complete tmux session
    with our project, or simply save it under version control and use it
    whenever we want to work back on it, without having it cluttering our
    sessions list every day.

### Global Sessions:

    Globals are... 'just sessions' in the sense that we're accustomed with
    tmuxinator.  A global session would, for example `cd` into some directory
    before executing a command.

### Remote Sessions:

    Why can't we manage tmux sessions in our servers the same way we do on our
    own computers?. Yat.sh gives us the ability to startup and attach to tmux
    sessions running on other hosts in a simple and transparent way.  Currently
    remote connections are done via ssh or mosh.

Installation:
-------------

If you're on a mac you can install via homebrew
([reference](https://github.com/farfanoide/homebrew-yatsh)):

Latest version (requires manual updating):

```bash
    $ brew install --HEAD https://raw.github.com/farfanoide/homebrew-yatsh/master/yatsh.rb
```

Stable version (supports updates via brew):

```bash
    $ brew tap farfanoide/yatsh
    $ brew install yatsh
```

Or you can manually download this repo and make sure `bin/yat.sh` is in your
$PATH

1. Download the repo into `~/.yat.sh`.

    ```bash
        $ git clone https://github.com/farfanoide/yat.sh ~/.yat.sh
    ```

2. Add `~/.yat.sh/bin` to your `$PATH`.  You can do it by adding the next line
into your shell config file (for zsh it would be ~/.zshr, for bash ~/.bashrc or
~/.bash_profile).

    ```bash
        export PATH="$HOME/.yat.sh/bin:$PATH"
    ```

    >If you just want to quickly test it, an alias would also work.


Usage:
------

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

#### Examples

List available example session files with a short description if available.
Descriptions can be added via custom data attributes.

```bash
    $ yat.sh examples
```

#### Help

Print usage for yat.sh itself or any other sucommand

```bash
    $ yat.sh help new
```

#### Link

Link local session file to global directory making it available from
anywhere.

```bash
    $ yat.sh link session_file
```

#### List

List available session files and optionally other running sessions. (alias =
ls)

```bash
    $ yat.sh list -a
```

#### Load

Start and setup a tmux session from a session file or attach to one already
running. If no session file is found an empty tmux session will be created and
attached to.

```bash
    $ yat.sh load session_file
```

#### Close

Close tmux sessions. Specify session name to close specific session. If `-a`
flag is given, close all tmux current sessions.

```bash
    $ yat.sh close session_name
```

#### New

Create a session file optionally from a predefined example. If `-l` flag is
given, the new file will be saved under the current directory oppsed to default
behaviour which would be to save it under `$YATSH_SESSIONS_DIR`

```bash
    $ yat.sh new session_name -e example_name
```

#### Edit

Open a session file for editing with your `$EDITOR` if set, otherwise with
`vi`.

```bash
    $ yat.sh edit session_file
```

#### Remote

Similar to `load` except on remote servers. `yat.sh remote` loads regular
session files but parses some custom data attributes, namely server and remote
session name. An `ssh` connection will try to be established to said server,
from then on, everything works just like with `yat.sh load` but on the remote
server.

>Example remote session:
>($YATSH_SESSIONS_DIR/remote_session)

```bash

    #= SERVER: root@myserver
    #= NAME: remote_session_name

    new_session -n 'General'

    send_line 'General' 'ls'
```

```
    $ yat.sh remote remote_session
```

In the previous example we are creating a session named 'remote_session_name' on
'myserver' as the user 'root'. Note that connections are done by default via ssh
which means that you can use aliases from your `~/.ssh/config`. if you want to
use mosh you have to also specify a `SERVICE` data attribute like so:

```bash
    #= SERVICE: mosh
```

If you want to use your local tmux configuration `~/.tmux.conf`
on the remote session you have to define the attribute:

```bash
    #= TMUX_CONFIG: yes
```

#### Version

    Print yat.sh version number.

Custom Data Attributes:
-----------------------

This is a simple way of entering extra information in session files which will
not be executed unless specifically parsed and used by a command. Basically
these data attributes are bash comments that follow a simple pattern:

```bash
    #= KEY: everything after the semicolon is used as value
```

Where and how to use them:

If you generate your own example session files, you might find it helpful to
add a description to them which will be parsed and shown whenever you call
`yat.sh examples`. Here's how:

```bash
    #= DESCRIPTION: Simple session running cmus
```

Remote session files take a number of data attrs, some optional and some
required, here's what each of them does:

`SERVER` &lt;required&gt; should be in the form of `user@server_ip` it could
alternatively be an alias set in your `~/.ssh/config` file.

`NAME` [optional] is the name for the tmux session. You might wanna have a
session called 'main' on every server you manage, this way your session files
can have different names from the sessions they'll launch.

`LOADER` [optional] would be the name of the plugin to load your session file.
this is helpful if you want to load your session files only by name (`yat.sh
'your_remote_session'`) instead of explicitly calling the desired plugin, ie:
`yat.sh remote 'your_remote_session'` For a remote session you would set `#=
LOADER: remote`



Creating session files:
-----------------------

Session files are scripts which will be invoked by `yat.sh` to start up tmux
sessions. Many helpers are provided in order to make this a much less painful
task.

### Helpers:

  > Most of these are pretty self explanatory

  1. Session helpers:

      ```bash
      new_session  # => this is the only required command on any session file.
      set_env      # => set environment vars
      set_path     # => set default path for new panes
      ```

  2. Window helpers:

      ```bash
      kill_window           # => kills given window
      new_window            # => creates new window, to give it a name call it with `-n 'window_name'`
      split                 # => default window splitting (horizontally)
      hsplit                # => split horizontally
      vsplit                # => split vertically
      select_window         # => target specific window onto which all further input should be directed
      rename                # => rename window
      select_layout         # => default layouts are: even-horizontal, even-vertical, main-horizontal, main-vertical, tiled.
      get_window_base_index # => window base index, useful for local session files to be shared
      ```

  3. Pane helpers:

      ```bash
      select_pane         # => selects given pane number
      send_keys           # => send set of characters as key-down events
      send_line           # => same as send_keys but adds a carriage return at the end
      swap                # => swap two panes
      get_pane_base_index # => pane base index, useful for local session files to be shared
      ```

  4. General helpers:

      ```bash
      get_global_option # => gets value for a global option
      get_window_option # => gets value for a window option
      ```

  5. Miscellaneous helpers:

      ```bash
      _height     # => get current terminal's height
      _width      # => get current terminal's width
      _portrait   # => true if terminal is tall
      _widescreen # => true if terminal is wide
      ```

CLI tab Completions:
--------------------

Currently there's only basic zsh and bash support for tab completions.

To enable tab completion in `zsh`, add the completion file to a directory in
your `fpath`:

```bash
mkdir -p ~/.zsh/completions
cp completions/_yat.sh.zsh ~/.zsh/completions/_yat.sh
```

Add the following to your .zshrc file to ensure tab completion is enabled and
the `~/.zsh/completions` directory is added to your `fpath`

```bash
autoload -U compinit

compinit

fpath=(~/.zsh/completions $fpath)
```

If you're doing this by hand you'll probably want to execute this too:

```bash
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
```


In bash it should work by sourcing the file directly.  For example you could
have a line lik this in yout `.bashrc`:

```bash
source "path_to_yat_sh_completions/yat.sh.bash"
```

Plugins:
--------

Yat.sh is extensible by plugins which can be written in any language, just
create an executable called `yatsh-{subcommand_name}` and add it somewhere on
the `$YATSH_PLUGINS_PATH` which follows the [XDG Base Directory Specification][xdg]
and by default is (in order of precedence):

```
~/.local/share/yat.sh/plugins
/usr/local/share/yat.sh/plugins
/usr/share/yat.sh/plugins
```

after that you can call your plugin like any other yat.sh subcommand:

```bash
yat.sh {subcommand_name} [arguments]
```

License:
--------

See the [LICENSE](LICENSE).

Contributing:
--------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

- [ ] TODO ## Test:


<!-- links -->
[tmux]:http://tmux.sourceforge.net
[tmuxstart]:https://github.com/treyhunner/tmuxstart
[tmuxinator]:https://github.com/tmuxinator/tmuxinator
[teamocil]:https://github.com/remiprev/teamocil
[xdg]:https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
<!-- end links -->
