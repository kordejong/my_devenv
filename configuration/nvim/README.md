# Neovim configuration


## Lua
- https://neovim.io/doc/user/lua.html
- https://neovim.io/doc/user/lua-guide.html


## Configure
- https://neovim.io/doc/user/starting.html#config
- https://neovim.io/doc/user/vim_diff.html#_configuration

- [X] https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/
- [ ] https://github.com/nvim-lua/kickstart.nvim

Example configurations, per plugin:
- https://www.lunarvim.org/docs/configuration/plugins/example-configurations


### Options

Options can be modified like this

```lua
vim.option.option_name = value
```

- :help option-list → for option_name
- :help option_name → for help about option



### Keybindings

```lua
vim.keymap.set({mode}, {lhs}, {rhs}, {opts})
```


### Plugins

- https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins


:checkhealth lazy

