local M = {}

local next_id = 1

function M.open(direction)
  vim.cmd(next_id .. "ToggleTerm direction" .. direction)
  next_id = next_id + 1
end

function M.new_horizontal()
  M.open("horizontal")
end

function M.new_vertical()
  M.open("vertical")
end

function M.new_float()
  M.open("float")
end

function M.new_tab()
  M.open("tab")
end

return M
