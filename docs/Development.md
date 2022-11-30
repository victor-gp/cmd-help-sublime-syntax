# Development

- [Requirements](#requirements)
- [Sublime Syntaxes](#sublime-syntaxes)
  * [This syntax](#this-syntax)
- [Testing](#testing)
  * [Syntax tests](#syntax-tests)
  * [Highlight regression tests](#highlight-regression-tests)
  * [Theme regression tests](#theme-regression-tests)
- [Finding pending tasks](#finding-pending-tasks)
- [Sample development workflow](#sample-development-workflow)
- [Contact](#contact)

## Requirements

- bash
- [docker](https://docs.docker.com/engine/install/)
- [python](https://www.python.org/downloads/)

I believe some of these make the project **unfit for development under Windows & Powershell.**

I'll be happy to update the setup to work there if an interested contributor is willing to drive this change.
(And I'm willing to pair program on this.)

On the other hand, the Windows Subsystem for Linux (WSL) should do just fine.

## Sublime Syntaxes

I cannot say much here that isn't better explained in **[the official documentation](https://www.sublimetext.com/docs/syntax.html#ver-3.2).**

More precisely, the targeted interpreter for the syntax is [`syntect`](https://github.com/trishume/syntect), a Rust implementation of Sublime Syntaxes used by `bat`.
For all intents and purposes, the Sublime Syntax documentation for v3.2 also applies to `syntect`.

Both Sublime Syntaxes and `syntect` use the Oniguruma regex engine, which follows [this specification](https://raw.githubusercontent.com/kkos/oniguruma/v6.9.1/doc/RE).
(No need to read through this though, just keep it as reference.)

### This syntax

You don't have to build or compile the syntax. The testing scripts take care of that, isolated within a Docker container. You only need to check the test results.

You should take a look at the [Principles doc](./Principles.md). It contains guidelines on the syntax's scope, coding style, etc.

I owe an Architecture doc on how the syntax is structured. In the meantime, if you get confused by how things work, ask me and I shall explain. (And I'll use that session to write the doc!)

You can also configure your IDE to highlight `.sublime-syntax` files like YAML code. For instance, I have this in my VS Code settings:

```json
"files.associations": {
    "*.sublime-syntax": "yaml"
},
```

## Testing

Tests in this project are cheap as fuck (in time & space) so don't hesitate to run them often and add new ones as required.

The project uses two classes of tests:

- syntax tests: much like unit tests
- regression tests: catch-all integration tests

There's a number of command-line utils I use to streamline development, including tests.
You can load them with `$ source scripts/env.sh`

### Syntax tests

These are assertion-based. They live in [`tests/syntax/`](../tests/syntax/).
You can find how they work in [the official documentation](http://www.sublimetext.com/docs/syntax.html#testing).

You can run them with `$ tests/syntax.py`

**Syntax tests should always pass.** If your changes break an assertion, update that assertion within the same commit.

If you expect the tests to pass, it's better to run them with the *summary* option: `$ tests/syntax.py -s`

Syntax tests are also useful to *debug* the workings of the syntax line by line.
If you can't make heads or tails of why something doesn't work, run `$ tests/syntax.py -d tests/syntax/<test file>`

`env.sh` also contains an util to run with debug and pipe the output to `less`: `$ debug tests/syntax/<test file>`

The `syntax -d` output is a bit hard to grasp unless you understand Sublime Syntaxes very well (not my case). So have patience and ask for help if you get stuck.

Lastly, there's an util to create a syntax test from a `tests/source/` help message: `$ mksyn tests/source/<source file>`

As a rule of thumb, if there's a syntax test for a command, it should also be in `tests/source`.

Sublime syntax regex can get quite obscure, but syntax test changes are a quick & easy reference of the implications of a syntax change.
For that, I like to pair both within the same commit, so the former serves as an example of the later.

### Highlight regression tests

These take all the samples (help messages from actual commands) in `tests/source` and run them through `bat` + `cmd-help`.
Then they store the result (syntax highlighted text) in `tests/highlighted/`.

You can run them with `$ tests/highlight_regression`

**They're good for quickly validating if your change breaks existing functionality.**

Because the result files contain color escape characters, they should be opened with `less -R`

To query their changes with respect to the git index, do `$ gdiff` (from `env.sh`)

For the diff between the index and the last commit (so staged changes), do `$ gdiffs`

These are also a great place to look at when looking for unhandled patterns, to document pending tasks.

To query them do: `less -R tests/highlighted/*`

or `less -R tests/highlighted/<test file>`

After a big syntax change that causes many highlight test files to update, it's ok not to include them in the same commit as the syntax change.

Instead, I focus on a syntax test example, or include just 2-3 representative regression tests in the commit.
Then I update the rest of the highlight tests in a follow-up commit.

For instance, see commit [6b0171b](https://github.com/victor-gp/cmd-help-sublime-syntax/commit/6b0171b9eba45d8459ffa5306f715c1c15636ccf)
and its follow-up [d158798](https://github.com/victor-gp/cmd-help-sublime-syntax/commit/d158798da8954c58cdaf84af82a2b1ba02a8ff01).

### Theme regression tests

These track the syntax's coverage for the themes included with `bat`. The motivation for which is [documented in Principles.md](Principles.md#scope-names).

**You probably don't need to look into these** unless you change the scopes that we assign to tokens. If you do, do follow the guidelines in the Principles doc.

You can run them with `$ tests/theme_regression`

It runs a synthetic help message through `bat` + `cmd-help`, twice for each theme: with and without italics enabled.
Then it store the result in `tests/theme_regression/`, but deleting the italics version if it makes no difference.

Everything I mentioned on `highlight_regression` applies here, just replacing `highlight` for `theme`.

As for committing scope name changes, I bundle the syntax change with the `tests/theme/` changes and leave syntax + highlight tests changes for a follow-up commit.

For example, see commit [47a0e8e](https://github.com/victor-gp/cmd-help-sublime-syntax/commit/47a0e8ebc9c3b53d149b18522aa7dfa68ca8863a)
and its follow-up [4689def](https://github.com/victor-gp/cmd-help-sublime-syntax/commit/4689def931c8fc84da4cca6bfb34fa1dd02e38f2).

## Finding pending tasks

I use comments in syntax tests as to-do markers, to indicate pending work and/or known issues.

The keywords I use are, in order of severity/priority: **fixme, todo, nice, nit, wontfix.**
For instance, `#todo: handle option patterns like this`.

If you search for these keywords in the project, you will find a lot of pending tasks.

I should probably make these into GitHub Issues, but I haven't got the chance to do it yet. You're welcome to lend a hand with this if you want!

There's also a [Roadmap doc](./Roadmap.md) that defines some long-term goals for the project.
Look there if you want to break entirely new ground.

## Sample development workflow

1. Search pending tasks with the to-do marker keywords. Choose one.
1. Update the assertion/s related to that task, negate it to make it fail.
1. Make whatever changes in the syntax to try and fix that test case.
1. Run `tests/syntax.py` to check the assertion now passes without breaking anything else.
1. Repeat steps 3-4 until you get it right.
1. Run `tests/highlight_regression.sh` to ensure the changes don't have unintended consequences in the larger body of help messages.
1. Run `tests/theme_regression.sh` to make double sure.
1. Commit, early and often!

## Contact

Contact me (@victor-gp) if you have trouble getting started, get stuck during development or want to ask for direction.

You can find my email address in the commit messages.
