# CHANGELOG

## Unreleased

- Modify setup instructions to source `zshrc` instead of symlinking to it ([#29](https://github.com/salcode/salcode-zsh/issues/29))
- Add `sayresult` alias for notification of completion (or failure) of a task (e.g. `npm install && sayresult`) ([#45](https://github.com/salcode/salcode-zsh/issues/45))

## [2.0.0] - 2023-09-24

- BREAKING CHANGE: Replace `gl` function with an alias to `git lg` without a fallback.
  See [2.0.0 Upgrade Path](https://github.com/salcode/salcode-zsh/wiki/Upgrade-Paths-for-Breaking-Releases#200) ([#42](https://github.com/salcode/salcode-zsh/issues/42))

## [1.3.0] - 2023-09-24

- Remove zplug ([#31](https://github.com/salcode/salcode-zsh/issues/31))
- Add alias `chompeof` to remove the newline at the end of a given file ([#20](https://github.com/salcode/salcode-zsh/issues/20))
- Add alias (function) `vrg` to open ripgrep results in Vim ([#36](https://github.com/salcode/salcode-zsh/issues/36))
- Add aliases to copy pwd (`pwdcp`) and to cd to clipboard (`cdp`) ([#35](https://github.com/salcode/salcode-zsh/issues/35))
- Add `.editorconfig` file ([#39](https://github.com/salcode/salcode-zsh/issues/39))
- Render `tab` character as 4 spaces, when viewing a file with the `less` command ([#34](https://github.com/salcode/salcode-zsh/issues/34))

## [1.2.0] - 2021-12-05

- Add git alias `gcanv` (for `git commit --amend --no-verify`)
- Add git alias `gbsc` (for `git branch --show-current`)
- Add alias `vi` to `nvim`
- Add environment variable `GPG_TTY` to make tty value available for GPG agent.
- Add `nvmpe` to read node version from `package.json` property `.engines.node` and run `nvm use` with the node version.

## [1.1.1] - 2021-08-12

- Fix alias `gl` to `git lg` with fallback

## [1.1.0] - 2020-12-07

- Add fzf completion for `go **<tab>`
- Add fzf completion for `git checkout **<tab>`
- Add fzf completion for `git switch **<tab>`
- Add parent directory aliases (e.g. `..3` for `cd ../../..`)
- Add `pu` alias for `./vendor/bin/phpunit`

## [1.0.0] - 2020-10-11

- Add nvm initialization
- Add zplug zsh plugin manager
- Add git aliases
- Add `sourcez` alias to `source ~/.zshrc`
- Modify PROMPT to display up to two directory names
- Add Git information to PROMPT
- Add colors to prompt
- Add fzf initialization
