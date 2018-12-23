# mini-formulae

A Homebrew tap with minimalistic formulae.

- [vim-mini](Formula/vim-mini.rb): the core [vim formula](https://github.com/Homebrew/homebrew-core/blob/master/Formula/vim.rb) requires gettext, lua, perl, python 3 and ruby. This formula requires only gettext and makes the languages optional.

## Usage

```sh
brew install robotvert/mini-formulae/<formula name> <options>

# for instance
brew install robotvert/mini-formulae/vim-mini --with-python
```
