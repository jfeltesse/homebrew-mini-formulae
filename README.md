# mini-formulae

A Homebrew tap with minimalistic formulae.

- [vim-mini](Formula/vim-mini.rb): Since Jan 2018, the core [vim](https://github.com/Homebrew/homebrew-core/blob/e3461b9bbf07d8805e3e08cc3177043b4f01528d/Formula/vim.rb) formula depends on ruby & perl and usually pulls python 3 as well. This mini version makes all languages bindings optional.

## Usage

```sh
brew install robotvert/mini-formulae/<formula name> <options>

# for instance
brew install robotvert/mini-formulae/vim-mini --with-gettext --with-python
```
