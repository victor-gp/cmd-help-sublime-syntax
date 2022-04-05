# cmd-help.sublime-syntax

This is a Sublime Syntax definition for [bat](https://github.com/sharkdp/bat) to colorize command `--help` messages.

It provides just enough color to help find your way around a help message:

<img src="./docs/assets/cmd-help-example.png" height="640" alt="Example usage of the cmd-help syntax on 'bat -h'">

Check out more examples [here](https://github.com/victor-gp/cmd-help-sublime-syntax/tree/demo/docs/examples).

## Install

To use this with `bat`, copy `syntaxes/cmd-help.sublime-syntax` into `"$(bat --config-dir)/syntaxes/"`. Then run `$ bat cache --build`.

Now you can use this with `$ SOME_COMMAND --help | bat -pl cmd-help`

You may want to use [an alias or a shell function](docs/bathelp.sh) around this.

## License

MIT © Víctor González Prieto
