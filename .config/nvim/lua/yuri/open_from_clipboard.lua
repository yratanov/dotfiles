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
