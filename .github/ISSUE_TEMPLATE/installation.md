---
name: Installation Issue
about: The syntax doesn't work after you tried the installation steps.
title: 'Installation: [TITLE]'
labels: installation
assignees: ''
---

### environment:

Output of `$ bat --diagnostic`:

<!--
Example:

#### Software version

bat 0.22.1

#### Operating system

Linux 5.15.0-76-generic

#### Command-line

```bash
bat --diagnostic
```

#### Environment variables

```bash
SHELL=/usr/bin/zsh
PAGER=less
LESS=<not set>
LANG=en_US.UTF-8
LC_ALL=<not set>
BAT_PAGER='less -R'
BAT_CACHE_PATH=<not set>
BAT_CONFIG_PATH=<not set>
BAT_OPTS=<not set>
BAT_STYLE=<not set>
BAT_TABS=<not set>
BAT_THEME=<not set>
XDG_CONFIG_HOME=<not set>
XDG_CACHE_HOME=<not set>
COLORTERM=truecolor
NO_COLOR=<not set>
MANPAGER='sh -c '\''col -bx | bat -p --language=man --theme=custom16'\'''
```

#### System Config file

Could not read contents of '/etc/bat/config': No such file or directory (os error 2).

#### Config file

```
# This is `bat`s configuration file. Each line either contains a comment or
# a command-line option that you want to pass to `bat` by default. You can
# run `bat --help` to get a list of all possible configuration options.

--theme="Dracula"
--italic-text=always
--color=always
```

#### Custom assets metadata

```
---
bat_version: 0.22.1
creation_time:
  secs_since_epoch: 1675707991
  nanos_since_epoch: 145212003
```

#### Custom assets

- metadata.yaml, 101 bytes
- syntaxes.bin, 907088 bytes
- themes.bin, 41171 bytes

#### Compile time information

- Profile: release
- Target triple: x86_64-unknown-linux-gnu
- Family: unix
- OS: linux
- Architecture: x86_64
- Pointer width: 64
- Endian: little
- CPU features: fxsr,sse,sse2
- Host: x86_64-unknown-linux-gnu

#### Less version

```
> less --version
less 551 (GNU regular expressions)
Copyright (C) 1984-2019  Mark Nudelman

less comes with NO WARRANTY, to the extent permitted by law.
For information about the terms of redistribution,
see the file named README in the less distribution.
Home page: http://www.greenwoodsoftware.com/less
```
-->
