--!strict
-- Services
-- Packages
-- Modules
local Parent = require(script.Parent)
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return function()
	local thr = task.spawn(Parent)
	return function()
		task.cancel(thr)
	end
end
