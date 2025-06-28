local M = {}

function M.mergeArrays(a, b)
	local z = {}
	local n = 0
	for _, v in ipairs(a) do
		n = n + 1
		z[n] = v
	end
	for _, v in ipairs(b) do
		n = n + 1
		z[n] = v
	end
	return z
end

return M
