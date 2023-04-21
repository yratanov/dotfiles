require("yuri.remap")
require("yuri.set")

vim.cmd('au TextYankPost * silent! lua vim.highlight.on_yank()')

function mysplit (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

OpenFileFromSystemClipboard = function()
  local file = vim.fn.getreg('+')
  local path = mysplit(file, ":")
  local result = ''
  if vim.fn.filereadable(path[1]) == 1  then
    if path[2] then
      vim.cmd('e +' .. path[2].. ' ' .. path[1])
    else
      vim.cmd('e ' .. path[1])
    end
  end
end

vim.api.nvim_set_keymap('n', '<leader>b', ':lua OpenFileFromSystemClipboard()<CR>', {noremap = true, silent = true})


vim.api.nvim_create_autocmd({'BufWritePost'}, {
  pattern = {"*.rb"},
  callback = function()
    local script = vim.fn.expand("~") .. '/.config/nvim/scripts/dry_auto_inject_to_yard.rb'
    local file_path = vim.fn.expand("%:p")
    local inflections = vim.fn.getcwd() .. '/config/initializers/inflections.rb'
    local deps = 'PulseAPI::Deps'

    vim.cmd('silent !' .. script .. ' ' .. file_path .. ' ' .. deps .. ' '  .. inflections)
  end,
  desc = "Auto inject yard doc",
})
