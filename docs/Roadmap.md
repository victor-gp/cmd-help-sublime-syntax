# Roadmap

## Current

0. Keep iterating on the syntax
    - [ ] handle more syntax patterns
    - [x] improve coverage of `bat` themes
1. Make contributions to the project easier
    - [x] add issue templates
    - [x] add CI setup for Pull Requests (with GitHub Actions)
    - [ ] docs v2: clear criteria for PRs, more detailed Development docs, etc.

## Later

In no particular order:

- [ ] **`cmd-help-full` / `helpful`**
  - alt syntax that colorizes tokens in descriptions, not just at the beginning of line.
  - If we like it better than the original one, make this default and keep the other in `cmd-help-less`. (we => poll bat mantainers and/or users)
  - It may work by importing `cmd-help` (OG) to handle beginning of line, and then handling the rest of the line within `cmd-help-full`.
- [ ] **PowerShell support**
  - Extend the syntax to better parse PowerShell-like help messages.
  - Should be pretty easy because help messages there are very structured.
  - Why bundle this in the same syntax? Commands in Windows show both Powershell-like help messages (`cd`) and Unix-like help messages (`npm`), it'd be useful to have one syntax to handle both.
