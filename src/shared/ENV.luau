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
}
setmetatable(DEFAULT_ENV, {
	__index = function(s, k): any?
		local v = _G[k]
		local dV = rawget(DEFAULT_ENV, k)
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
})
return DEFAULT_ENV
