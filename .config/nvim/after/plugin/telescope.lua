local builtin = require('telescope.builtin')

local function dasherize(str)
  return (string.gsub(str, '%W+', '-'))
end

local function decamelize(str)
  return string.lower((string.gsub(str, '(%l)(%u)', '%1_%2')))
end


vim.keymap.set('n', '<leader>o', function()
  builtin.find_files({ hidden = true })
end)
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>e', function()
  builtin.oldfiles({ only_cwd = true })
end, {})
vim.keymap.set('n', '<leader>fb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>fs', builtin.git_stash, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fc', function()
  builtin.find_files({ search_file = dasherize(decamelize(vim.fn.expand("<cword>"))) })
end)

vim.keymap.set('n', '<leader>gf', function()
  vim.cmd(':e spec/factories/' .. decamelize(vim.fn.expand("<cword>")) .. 's.rb')
end)
vim.keymap.set('n', '<leader>fh', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ';;', function()
  builtin.resume()
end)
require("telescope").load_extension "file_browser"
local file_browser = require "telescope".extensions.file_browser
file_browser.hidden = true
vim.keymap.set('n', '<space>fd', function() file_browser.file_browser({ path = "%:p:h", select_buffer = true }) end)


function mergeArrays(a, b)
  local z = {}
  local n = 0
  for _,v in ipairs(a) do n=n+1; z[n]=v end
  for _,v in ipairs(b) do n=n+1; z[n]=v end
  return z
end

function generate_spec_mapping(base_path, mapping)
  return {
    {
      base_path .. '/' .. mapping .. '/(.*).rb',
      {
        { 'spec/' .. mapping .. '/[1]_spec.rb', 'Test', true },
      }
    },
    {
      'spec/' .. mapping .. '/(.*)_spec.rb',
      {
        { base_path .. '/' .. mapping .. '/[1].rb', 'Model', true },
      }
    }
  }
end


local ruby_mappings = {}

for _, mapping in ipairs({ 'controllers', 'models', 'mailers', 'serializers', 'policies', 'jobs' }) do
  ruby_mappings = mergeArrays(ruby_mappings, generate_spec_mapping('app', mapping))
end

for _, mapping in ipairs({ 'request', 'service' }) do
  ruby_mappings = mergeArrays(ruby_mappings, generate_spec_mapping('lib', mapping))
end

require('telescope-alternate').setup({
  mappings = mergeArrays({
    {
      'app/components/(.*).hbs',
      {
        { 'app/components/[1].js',                    'Component JS',   true },
        { 'app/components/[1].ts',                    'Component TS',   true },
        { 'tests/integration/components/[1]-test.js', 'Component test', true },
      }
    },
    {
      'app/components/(.*).[jt]s$',
      {
        { 'app/components/[1].hbs',                   'Component HBS' },
        { 'tests/integration/components/[1]-test.js', 'Component test', true },
      }
    },
    {
      'tests/integration/components/(.*)-test.js',
      {
        { 'app/components/[1].hbs', 'Component HBS' },
        { 'app/components/[1].js',  'Component JS', true },
        { 'app/components/[1].ts',  'Component TS', true },
      }
    },
    {
      'app/routes/(.*).[jt]s$',
      {
        { 'app/controllers/[1].js', 'Controller JS', true },
        { 'app/controllers/[1].ts', 'Controller TS', true },
        { 'app/templates/[1].hbs',  'Template',      true },
      }
    },
    {
      'app/controllers/(.*).[jt]s$',
      {
        { 'app/routes/[1].js',     'Route JS', true },
        { 'app/routes/[1].ts',     'Route TS', true },
        { 'app/templates/[1].hbs', 'Template', true },
      }
    },
    {
      'app/templates/(.*).hbs',
      {
        { 'app/routes/[1].js',      'Route JS',      true },
        { 'app/routes/[1].ts',      'Route TS',      true },
        { 'app/controllers/[1].js', 'Controller JS', true },
        { 'app/controllers/[1].ts', 'Controller TS', true },
      }
    },
    {
      'lib/tasks/(.*).thor',
      {
        { 'spec/tasks/[1]_spec.rb', 'Test', true },
      }
    },
    {
      'lib/tasks/(.*).rake',
      {
        { 'spec/tasks/[1]_spec.rb', 'Test', true },
      }
    },
    {
      'spec/tasks/(.*)_spec.rb',
      {
        { 'lib/tasks/[1].rake', 'Rake', true },
        { 'lib/tasks/[1].thor', 'THOR', true },
      }
    }
  }, ruby_mappings),
  presets = {}, -- Telescope pre-defined mapping presets
})

vim.keymap.set('n', '<leader>ll', ':Telescope telescope-alternate alternate_file<Cr>')
