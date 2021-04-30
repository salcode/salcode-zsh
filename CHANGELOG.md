# CHANGELOG

## [Unreleased]

- Remove fallback for `gl` (previously, if `git lg` was not defined `git log --oneline --graph` was used - this is now removed)
- Add git alias `gcanv` (for `git commit --amend --no-verify`)
- Add git alias `gbsc` (for `git branch --show-current`)
- Add alias `vi` to `nvim`

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
