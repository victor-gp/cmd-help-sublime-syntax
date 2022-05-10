# cmd-help.sublime-syntax

This is a Sublime Syntax definition for [`bat`](https://github.com/sharkdp/bat) to colorize command `--help` messages.

It provides just enough color to help find your way around a help message:

<img src="./docs/assets/cmd-help-example.png" width="750" alt="Example usage of the cmd-help syntax on 'bat -h'">

Check out more examples [here](https://github.com/victor-gp/cmd-help-sublime-syntax/tree/demo/docs/examples).

## Installation

This syntax is included with `bat` if you [build from source](https://github.com/sharkdp/bat#from-source).

But it hasn't made it into a release yet, so if you installed `bat` from a package manager you'll have to [add it as a custom syntax](https://github.com/sharkdp/bat#adding-new-syntaxes--language-definitions).

Check things work by running `mv --help | bat -plhelp`

## Streamline it

You may want to put an alias plus a function around this:

```sh
# in your .bashrc/.zshrc/.*rc
alias bathelp='bat --plain --language=cmd-help'
help() (
    set -o pipefail
    "$@" --help 2>&1 | bathelp
)
```

Then you can do `help git`. Or `help git commit`. Depending on the command, it can even handle alternative help options: `help bat -h`.

Sometimes a command may not recognize `--help`. (I'm looking at you, `java`, though `help java -h` does work.) In that case, you just have to run `<the command> --its-help-option | bathelp`.

## `bat` theme support

The syntax works nicely with most `bat` themes. In some cases, even better than with the default theme (used in the above example). You can find examples of working themes [here](https://github.com/victor-gp/cmd-help-sublime-syntax/tree/demo/docs/examples/theme).

If you want to use a different theme, just append `--theme=<your preferred theme>` to your `bat` commands. More info [here](https://github.com/sharkdp/bat#highlighting-theme).

## License

MIT © Víctor González Prieto
