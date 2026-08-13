local terminal = require("user.terminal")

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

Map("n", "<C-d>", ":lua vim.diagnostic.open_float()<CR>")

-- Toggleterm maps (custom)
Map("n", "<leader>th", terminal.new_horizontal )  -- Split orizzontale
Map("n", "<leader>tv", terminal.new_vertical)    -- Split verticale
Map("n", "<leader>tf", terminal.new_float )       -- Floating
Map("n", "<leader>tt", terminal.new_tab)       -- tab
Map("n", "<leader>ts", ":TermSelect<CR>")                       -- Seleziona terminale

-- Terminali numerici
Map("n", "t", function()
  local count = vim.v.count

  if count == 0 then
    vim.cmd("ToggleTerm")
  else
    vim.cmd(count .. "ToggleTerm")
  end
end, { desc = "Toggle terminal" })

-- Terminal mode: esci con <Esc><Esc>
Map("t", "<Esc><Esc>", [[<C-\><C-n>]])

-- Search selected text (from old init.vim)
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

-- ============================================================================
-- LSP Keymaps con Floating Window per definizioni
-- ============================================================================

-- Helper per aprire definizioni LSP in floating window
local function lsp_floating_location(method)
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request_all(0, method, params, function(results)
    local result = nil
    for _, res in pairs(results) do
      if res.result then
        result = res.result[1] or res.result
        break
      end
    end

    if not result then
      print("No location found")
      return
    end

    local uri = result.uri or result.targetUri
    local range = result.range or result.targetSelectionRange

    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      vim.fn.bufload(bufnr)
    end

    -- Calcola dimensioni della finestra
    local start_line = range.start.line
    local lines_in_def = (range["end"].line - start_line) + 1
    local height = math.max(lines_in_def + 4, 10)
    local width = math.floor(vim.o.columns * 0.6)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Crea la floating window
    local win = vim.api.nvim_open_win(bufnr, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
    })

    -- Posiziona il cursore all'inizio della definizione
    vim.api.nvim_win_set_cursor(win, { start_line + 1, range.start.character })

    -- Mappa 'q' e <Esc> per chiudere la finestra
--    vim.keymap.set("n", "q", ":close<CR>", { buffer = bufnr, silent = true, nowait = true })
--    vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = bufnr, silent = true, nowait = true })
--
--    -- Mappa 'a' per aprire il file in una nuova tab
--    vim.keymap.set("n", "a", function()
--      vim.api.nvim_win_close(win, true)
--      vim.cmd("tabnew")
--      vim.api.nvim_set_current_buf(bufnr)
--      vim.api.nvim_win_set_cursor(0, { start_line + 1, range.start.character })
--      local empty_bufs = vim.tbl_filter(function(b)
--        return vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) == ""
--      end, vim.api.nvim_list_bufs())
--      for _, eb in ipairs(empty_bufs) do
--        if eb ~= bufnr then
--          vim.api.nvim_buf_delete(eb, { force = true })
--        end
--      end
--    end, { buffer = bufnr, silent = true, nowait = true })

    -- Mappa 'e' per sostituire il buffer corrente
    vim.keymap.set("n", "e", function()
      vim.api.nvim_win_close(win, true)
      local cur_tab = vim.api.nvim_get_current_tabpage()
      local cur_win = vim.api.nvim_get_current_win()
      
      vim.api.nvim_set_current_buf(bufnr)
      vim.api.nvim_win_set_cursor(cur_win, { start_line + 1, range.start.character })

      local empty_bufs = vim.tbl_filter(function(b)
        return vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) == ""
      end, vim.api.nvim_list_bufs())
      for _, eb in ipairs(empty_bufs) do
        if eb ~= bufnr and eb ~= vim.api.nvim_get_current_buf() then
          vim.api.nvim_buf_delete(eb, { force = true })
        end
      end
    end, { buffer = bufnr, silent = true, nowait = true })
  end)
end

-- LSP Keymaps (con floating windows per definizioni)
Map("n", "gd", function() lsp_floating_location("textDocument/definition") end, { desc = "Definition (float)" })
Map("n", "gD", function() lsp_floating_location("textDocument/declaration") end, { desc = "Declaration (float)" })
Map("n", "gi", function() lsp_floating_location("textDocument/implementation") end, { desc = "Implementation (float)" })
Map("n", "gr", vim.lsp.buf.references, { desc = "References" })
Map("n", "K", vim.lsp.buf.hover, { desc = "Hover doc" })
Map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
Map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
Map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
Map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
Map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
Map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- LaTeX keymaps
Map("n", "<leader>lb", ":VimtexCompile<CR>", { desc = "LaTeX build" })
Map("n", "<leader>ls", ":VimtexStop<CR>", { desc = "LaTeX stop build" })
Map("n", "<leader>lv", function()
  local pdf_path = vim.fn.expand('%:p:h') .. '/out/' .. vim.fn.expand('%:t:r') .. '.pdf'
  if vim.fn.filereadable(pdf_path) == 1 then
    os.execute('zathura "' .. pdf_path .. '" >/dev/null 2>&1 &')
  else
    print("PDF not found: " .. pdf_path)
  end
end, { desc = "LaTeX view PDF" })
Map("n", "<leader>lc", ":VimtexClean<CR>", { desc = "LaTeX clean" })
Map("n", "<leader>lt", ":VimtexTocToggle<CR>", { desc = "LaTeX TOC" })
Map("n", "<leader>le", ":VimtexErrors<CR>", { desc = "LaTeX errors" })
