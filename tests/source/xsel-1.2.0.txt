Usage: xsel [options]
Manipulate the X selection.

By default the current selection is output and not modified if both
standard input and standard output are terminals (ttys).  Otherwise,
the current selection is output if standard output is not a terminal
(tty), and the selection is set from standard input if standard input
is not a terminal (tty). If any input or output options are given then
the program behaves only in the requested mode.

If both input and output is required then the previous selection is
output before being replaced by the contents of standard input.

Input options
  -a, --append          Append standard input to the selection
  -f, --follow          Append to selection as standard input grows
  -z, --zeroflush       Overwrites selection when zero ('\0') is received
  -i, --input           Read standard input into the selection

Output options
  -o, --output          Write the selection to standard output

Action options
  -c, --clear           Clear the selection
  -d, --delete          Request that the selection be cleared and that
                        the application owning it delete its contents

Selection options
  -p, --primary         Operate on the PRIMARY selection (default)
  -s, --secondary       Operate on the SECONDARY selection
  -b, --clipboard       Operate on the CLIPBOARD selection

  -k, --keep            Do not modify the selections, but make the PRIMARY
                        and SECONDARY selections persist even after the
                        programs they were selected in exit.
  -x, --exchange        Exchange the PRIMARY and SECONDARY selections

X options
  --display displayname
                        Specify the connection to the X server
  -t ms, --selectionTimeout ms
                        Specify the timeout in milliseconds within which the
                        selection must be retrieved. A value of 0 (zero)
                        specifies no timeout (default)

Miscellaneous options
  -l, --logfile         Specify file to log errors to when detached.
  -n, --nodetach        Do not detach from the controlling terminal. Without
                        this option, xsel will fork to become a background
                        process in input, exchange and keep modes.

  -h, --help            Display this help and exit
  -v, --verbose         Print informative messages
  --version             Output version information and exit

Please report bugs to <conrad@vergenet.net>.
