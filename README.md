# salcode-zsh
My zsh configuration and notes.

## Aliases

### General

- `sourcez` for `source ~/.zshrc`

## Setup

Clone the directory in your home directory.

```
git clone git@github.com:salcode/salcode-zsh.git ~/salcode-zsh.git
```

Add `source ~/salcode-zsh/zshrc` to the bottom of your `~/.zshrc` file by running the command:

```
echo 'source ~/salcode-zsh/zshrc' >> ~/.zshrc
```

### Add fzf

Install fzf by running

```
brew install fzf && $(brew --prefix)/opt/fzf/install --all
```
