# cmd-help.sublime-syntax

Sublime Syntax definition for [`bat`](https://github.com/sharkdp/bat) to colorize command `--help` messages.

It provides just enough color to help find your way around a help message.

<img src="./docs/assets/cmd-help-example.png" width="700" alt="Example usage of the cmd-help syntax on 'bat -h'">

[See examples from other help messages.](https://github.com/victor-gp/cmd-help-sublime-syntax/tree/demo/examples)

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
  * [Streamline it](#streamline-it)
  * [`bat` theme support](#bat-theme-support)
- [Contributing](#contributing)
- [License](#license)

## Installation

This syntax is included with `bat` since version 0.21.0.

If you have an older version of `bat` or you want the latest version of `cmd-help`, you can [add it as a new syntax](https://github.com/sharkdp/bat#adding-new-syntaxes--language-definitions). You should copy [this file](./syntaxes/cmd-help.sublime-syntax).

To check that everything works, run `git --help | bat -plhelp`

## Configuration

### Streamline it

You may want to put an alias plus a function around this in your `.bashrc`/`.zshrc`/`.*rc`:

```sh
alias bathelp='bat --plain --language=cmd-help'
help() (
    set -o pipefail
    "$@" --help 2>&1 | bathelp
)
```

Then you can do `help git`. Or `help git commit`.

Depending on the command, `help()` will even handle alternative help options, e.g.: `help bat -h`.

If `help()` doesn't work with a command's alternative help option, you can still do `CMD --help-option | bathelp`.

### `bat` theme support

The syntax works nicely with most `bat` themes. You can find examples of working themes [here](https://github.com/victor-gp/cmd-help-sublime-syntax/tree/demo/examples/theme).

To use a different theme, just append `--theme='<THEME_NAME>'` to your `bat` commands. More info [here](https://github.com/sharkdp/bat#highlighting-theme).

You may also want to experiment with setting `--italic-text=always`. A few themes use italics on some elements, including Monokai.

## Contributing

Contributions are welcome! :D

Make sure to give [CONTRIBUTING.md](./CONTRIBUTING.md) a cursory read to learn how you can help.

If you want to hack on the project, look at [the Development doc](./docs/Development.md) to help get you started.

## License

MIT © Víctor González Prieto
