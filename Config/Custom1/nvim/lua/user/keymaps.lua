function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

vim.g.mapleader = " "


-- Save with ctrl + s
Map("n", "<C-s>", ":w<CR>")
Map("n", "<C-o>", ":vsplit<CR>")
Map("n", "<C-p>", ":split<CR>")
Map("n", "<C-q>", ":q<CR>")
Map("n", "<S-q>", ":qa<CR>")
Map("n", "<C-t>", ":tabnew<CR>")

-- Navigation through the splits
Map("n", "<C-up>", "<C-w><up>")
Map("n", "<C-down>", "<C-w><down>")
Map("n", "<C-left>", "<C-w><left>")
Map("n", "<C-right>", "<C-w><right>")

Map("n", "<C-a>", ":NvimTreeOpen<CR>")
Map("n", "gg", ":LazyGit<CR>")

-- Telescope maps
local builtin = require('telescope.builtin')
Map('n', 'ff', builtin.find_files)
Map('n', 'fg', builtin.live_grep)
Map('n', 'fb', builtin.buffers)
Map('n', 'fh', builtin.help_tags)


Map("n", "<C-/>", ":TermNew direction=horizontal<CR>")
Map("n", "<C-.>", ":TermNew direction=vertical<CR>")
Map("n", "<C-,>", ":TermNew direction=tab<CR>")
Map("n", "<C-f>", ":TermNew direction=float<CR>")
Map("n", "<S-T>", ":TermSelect<CR>")

Map("n", "<C-\'>", function() print("ciao") end)

Map("t", "C-esc", [[<C-\><C-n>]])
