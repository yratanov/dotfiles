local M = {}

local storage_path = vim.fn.stdpath("data") .. "/project_config.json"

local function load_project_config()
	local f = io.open(storage_path, "r")
	if not f then
		return {}
	end
	local content = f:read("*a")
	f:close()
	return vim.fn.json_decode(content)
end

local function save_project_config(data)
	local f = io.open(storage_path, "w")
	if not f then
		return
	end
	f:write(vim.fn.json_encode(data))
	f:close()
end

local function get_project_id()
	return vim.fn.getcwd()
end

local function load_key(key)
	local all_keys = load_project_config()
	local project_config = all_keys[get_project_id()]
	if project_config == nil then
		return nil
	else
		return project_config[key]
	end
end

local function save_key(key, value)
	local all_keys = load_project_config()
	local project_config = all_keys[get_project_id()]
	if project_config == nil then
		all_keys[get_project_id()] = {}
	end
	all_keys[get_project_id()][key] = value
	save_project_config(all_keys)
end

function M.get_project_config(key)
	return load_key(key)
end

function M.set_project_config(key, value)
	save_key(key, value)
end

return M
