return {
    {
        "vimwiki/vimwiki",
        init = function()
            -- This function (init instead of config) is runs before VimWiki loads
            if(vim.env.PERSONAL_FILES)
            then
                local wikipath = vim.env.PERSONAL_FILES .. "/Environment/configuration/vimrc"
                vim.api.nvim_cmd({cmd = "source", args = { wikipath }}, {})
            end
        end,
    },
}
