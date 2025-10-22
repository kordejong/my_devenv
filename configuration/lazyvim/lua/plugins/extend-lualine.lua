return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          function()
            return " " .. os.date("%Y%m%d %H:%M")
          end,
        },
      },
    },
  },
}
