-- Key mappings helper function

local function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Leader key
vim.g.mapleader = " "

-- Basic navigation and save
Map("n", "<C-s>", ":w<CR>")
Map("n", "<C-o>", ":vsplit<CR>")
Map("n", "<C-p>", ":split<CR>")
Map("n", "<C-q>", ":q<CR>")
Map("n", "<S-q>", ":qa<CR>")
Map("n", "<C-t>", ":tabnew<CR>")

-- Split navigation
Map("n", "<C-up>", "<C-w>up")
Map("n", "<C-down>", "<C-w>down")
Map("n", "<C-left>", "<C-w>left")
Map("n", "<C-right>", "<C-w>right")

-- Plugin shortcuts
Map("n", "<C-a>", ":NvimTreeOpen<CR>")
Map("n", "gg", ":LazyGit<CR>")

-- Telescope maps
local builtin = require("telescope.builtin")
Map("n", "ff", builtin.find_files)
Map("n", "fg", builtin.live_grep)
Map("n", "fb", builtin.buffers)
Map("n", "fh", builtin.help_tags)

-- Toggleterm maps
Map("n", "<C-/>", ":ToggleTerm direction=horizontal<CR>")
Map("n", "<C-.>", ":ToggleTerm direction=vertical<CR>")
Map("n", "<C-,>", ":ToggleTerm direction=tab<CR>")
Map("n", "<C-f>", ":ToggleTerm direction=float<CR>")
Map("n", "<S-T>", ":ToggleTermSelect<CR>")

-- Debug/test map
Map("n", "<C-'>", function() print("ciao") end)

-- Terminal escape
Map("t", "<C-esc>", [[<C-\><C-n>]])

-- Search selected text (from old init.vim)
-- Press * to search forwards, # to search backwards
vim.cmd([[
  vnoremap <silent> * :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gVzv:call setreg('"', old_reg, old_regtype)<CR>
]])

vim.cmd([[
  vnoremap <silent> # :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gVzv:call setreg('"', old_reg, old_regtype)<CR>
]])
