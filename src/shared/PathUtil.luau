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
local Util = {}

function Util.toPath(inst: Instance): string
	local path = inst:GetFullName()
	path = path:gsub("%.", "/")
		:gsub("ServerScriptService/Server/", "src/server/")
		:gsub("ReplicatedStorage/Shared/", "src/shared/")
		:gsub("ReplicatedStorage/Client/", "src/client/")
	return path
end

return Util
