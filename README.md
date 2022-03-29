# cmd-help.sublime-syntax

This is a Sublime Syntax definition for [bat](https://github.com/sharkdp/bat) to colorize command `--help` messages.

It provides just enough color to help find your way around a help message. You can find some examples [here](https://github.com/victor-gp/cmd-help-sublime-syntax/tree/demo/docs/examples).

And here's how it compares to the [currently recommended](https://github.com/sharkdp/bat/issues/1430) man syntax:

![bat -h colorized with the man and cmd-help syntaxes](./docs/assets/vs-man-syntax-1.png)

![mv --help colorized with the man and cmd-help syntaxes](./docs/assets/vs-man-syntax-2.png)

## Install

To use this with `bat`, copy the `syntaxes/cmd-help.sublime-syntax` file into `"$(bat --config-dir)/syntaxes/"`. Then run `$ bat cache --build`.

Now you can use this with `$ SOME_COMMAND --help | bat -pl cmd-help`.

You may want to use [an alias or a shell function](docs/bathelp.sh) around this.

## License

MIT © Víctor González Prieto
