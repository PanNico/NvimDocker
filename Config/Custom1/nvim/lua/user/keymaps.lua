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
Map("n", "<C-g>", ":LazyGit<CR>")

-- Telescope maps
local builtin = require("telescope.builtin")
Map("n", "ff", builtin.find_files)
Map("n", "fg", builtin.live_grep)
Map("n", "fb", builtin.buffers)
Map("n", "fh", builtin.help_tags)

-- Diagnostic
Map("n", "<C-d>", ":lua vim.diagnostic.open_float()<CR>")

-- Toggleterm maps (fixed)
Map("n", "<C-\\>", ":ToggleTerm<CR>")           -- Apri/chiudi terminale floating (già configuato come default)
Map("n", "<leader>/", ":TermNew direction=horizontal<CR>")  -- Orizzontale (leader+t+h)
Map("n", "<leader>.", ":TermNew direction=vertical<CR>")    -- Verticale (leader+t+v)
Map("n", "<C-f>", ":TermNew direction=float<CR>")       -- Floating (leader+t+f)
Map("n", "<leader>ts", ":TermSelect<CR>")                       -- Seleziona terminale (leader+t+s)

-- Terminali numerici
Map("n", "<leader>t1", ":1ToggleTerm<CR>")
Map("n", "<leader>t2", ":2ToggleTerm<CR>")
Map("n", "<leader>t3", ":3ToggleTerm<CR>")

-- Terminal mode: esci con <Esc><Esc>
Map("t", "<Esc><Esc>", [[<C-\><C-n>]])

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


-- LaTeX keymaps

-- Compila il documento (continuous mode)
Map("n", "<leader>lb", ":VimtexCompile<CR>", { desc = "LaTeX build" })

-- Ferma la compilazione
Map("n", "<leader>ls", ":VimtexStop<CR>", { desc = "LaTeX stop build" })

-- Apri il PDF con Zathura (silenzioso, redirect a /dev/null)
Map("n", "<leader>lv", function()
  local pdf_path = vim.fn.expand('%:p:h') .. '/out/' .. vim.fn.expand('%:t:r') .. '.pdf'
  if vim.fn.filereadable(pdf_path) == 1 then
    os.execute('zathura "' .. pdf_path .. '" >/dev/null 2>&1 &')
  else
    print("PDF not found: " .. pdf_path)
  end
end, { desc = "LaTeX view PDF" })

-- Pulisci i file ausiliari
Map("n", "<leader>lc", ":VimtexClean<CR>", { desc = "LaTeX clean" })

-- Mostra/nascondi l'indice (Table of Contents)
Map("n", "<leader>lt", ":VimtexTocToggle<CR>", { desc = "LaTeX TOC" })

-- Mostra gli errori di compilazione
Map("n", "<leader>le", ":VimtexErrors<CR>", { desc = "LaTeX errors" })
