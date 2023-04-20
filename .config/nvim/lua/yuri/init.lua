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
  vim.cmd('e +' .. path[1].. ' ' .. path[0])
end

