# Principles

- [Trade offs](#trade-offs)
- [Tests first](#tests-first)
- [Scope names](#scope-names)
  * [Constraint on Monokai](#constraint-on-monokai)
- [Coding style](#coding-style)

## Trade offs

- **False positives << False negatives.** Colorizing normal text by mistake is much worse than leaving a relevant token unstyled.
- **Consistency:** if we can't consistently target a class of token, we should just not.
- **Not handling corner cases is ok.** If doing so would break common cases, add too much complexity to the syntax, etc.
- It's ok to hardcode segments from widely used help message generators (e.g.: look up "argparse" within the syntax file).
- **Everything is up to discussion:** if you're not sure about a particular change, prototype it and let's talk after seeing the result.

## Tests first

This project makes extensive use of TDD because I have yet to wrap my head around Sublime Syntaxes.

Tests are super cheap in this small project and they allow me to **iterate speculatively**
(read: I don't know what I'm doing) **without having to worry about breaking things.**

It also doesn't help that sublime syntaxes weren't designed for help messages.
Many of their features are useful to hook into patterns and structure that programming languages have, but help messages lack.

In summary: **we write tests first, logic later.**

## Scope names

In this project, **we don't care about the correct use of scope names.**

Command help messages don't conform to a language, not even a markup one. There's no point in following conventions designed for those languages.

This is a syntax made with `bat` in mind, and we assign our scopes to _overfit_ the themes included with `bat`.

Because syntax themes target some scopes and ignore some others (leaving them with the default foreground color), the syntax assigns multiple scopes to every token class.

For instance:

```yaml
scope_variables:
  - &SECTION_HEADING_SCOPES
    constant.section-heading.cmd-help
    string.section-heading.cmd-help
    markup.heading.cmd-help
    entity.name.section.cmd-help
```

**An optimal scope assignation is one where every `bat` theme styles each token class with a different color.** But that's probably impossible.

Just know that [there's a convention for scope names](https://www.sublimetext.com/docs/scope_naming.html), and syntax themes target those names.

### Constraints on Monokai

There are a couple of constraints I would like to preserve.

The help messages generated with the `clap` Rust library were the original inspiration for this project\*.
They painted **headings in yellow\*\* and option definitions in green.**

I'd like those two properties to hold for the default Monokai theme.

Everything else is fair game. Even that constraint is bound to drop if you make a compelling case otherwise.

\* Before clap v4, which ditched colors for style (bold, underlined) in help messages.

\*\* In the theme I use in my terminal (srcery), yellow means golden. So favor e.g. golden orange over pale yellow.

## Coding style

- **Readability >> DRY**, prefer A over B:

  ```yaml
  # A
  option-def-connectors:
    - match: ', '
      set: option-def-alt
    - match: ' \| '
      set: option-def-alt
    - match: ' (?=-)'
      set: option-def-alt
    - match: ' or '
      set: option-def-alt
    - match: '  or  '
      set: option-def-alt
    - match: '/'
      set: option-def-alt
    - match: '\s+(?=-)'
      set: option-def-alt
  ```

  ```yaml
  # B
  option-def-connectors:
    - match: ', | \| | (?=-)| or |  or  |/|\s+(?=-)'
      set: option-def-alt
  ```

  This decoupling also makes it easier to change the way we handle any of these patterns, to treat it as a special case.

- You may do B depending on the context, but then you should **illustrate with comments**:

  ```yaml
  option-def-post:
    - include: option-def-connectors
    - match: '='
      set: option-def+equals
    # match '[=' or '[' or ' [' or ':['
    - match: '\[=|\[| \[|:\['
      set: option-def+square-bracket
    - match: ':'
      set: option-def+colon
    # etc
  ```
