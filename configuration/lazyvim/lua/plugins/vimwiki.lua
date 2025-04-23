-- https://namoku.dev/blog/how-do-i-setup-lazyvim/
-- https://github.com/LazyVim/LazyVim/discussions/258

return {
  {
    "vimwiki/vimwiki",
    -- keys = {"<leader>ww", "<leader>ws"},
    init = function()
      -- This function (init instead of config) runs before VimWiki loads
      if vim.env.PERSONAL_FILES then
        -- local wikipath = vim.env.PERSONAL_FILES .. "/Environment/configuration/vimrc"
        -- vim.api.nvim_cmd({cmd = "source", args = { wikipath } }, {})
        vim.g.vimwiki_list = {
          {
            path = "$PERSONAL_FILES/Documents/wiki",
            -- nested_syntaxes = {
            --   \ 'python': 'python',
            --   \ 'c++': 'cpp',
            --   \ 'bash': 'sh',
            --   \ 'haskell': 'hs'}
            -- maxhi = 1
            -- syntax = "markdown",
            -- ext = ".wiki",
          },
          {
            path = "$PERSONAL_FILES/../../geoneric/executive/geoneric/document/wiki",
          },
        }
        -- Don't treat every Markdown file as a VimWiki file
        vim.g.vimwiki_global_ext = 0
      end
    end,
  },
}
