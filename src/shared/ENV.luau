--!strict
-- Services
-- Packages
-- Modules
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local DEFAULT_ENV = {
	IS_VERBOSE = true,
	FILTER_PATH = "",
	IS_DEBUG = true,
	IS_FLAT = false,
	DATA_DIR = "data/src",
	AGENT_OUTPUT = {
		summary = "",
		raw = {},
	} :: {
		summary: string,
		raw: { [string]: string },
	},
}
local out = setmetatable({}, {
	__index = function(_, k): any?
		local v = _G[k]
		local dV = rawget(DEFAULT_ENV, k)
		if dV == nil then
			error(`Attempt to access undefined key "{k}" in ENV`)
		end
		if typeof(v) == "string" then
			if typeof(dV) == "boolean" then
				if v == "true" then
					return true
				elseif v == "false" then
					return false
				else
					return dV
				end
			elseif typeof(dV) == "number" then
				local n = tonumber(v)
				if n ~= nil then
					return n
				else
					return dV
				end
			end
		end
		if v == nil then
			return dV
		else
			return v
		end
	end,
	__newindex = function(_, k, v)
		assert(rawget(DEFAULT_ENV, k) ~= nil, `Attempt to set undefined key "{k}" in ENV`)
		_G[k] = v
	end,
})

return out :: typeof(DEFAULT_ENV)
