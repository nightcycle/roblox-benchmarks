--!strict
local RunService = game:GetService("RunService")
-- Services
-- Packages
-- Modules
local FileUtil = require(script.FileUtil)
-- Types
-- Constants
local DEBUG_PREFIX = "data"
local IS_DEBUG = RunService:IsStudio()
-- Variables
-- References
-- Private Functions
function getDebugFinalPath(path: string): string
	return DEBUG_PREFIX .. "/" .. path
end
-- Class
local Util = {}

function Util.saveCSV(path: string, content: string)
	if IS_DEBUG then
		local filePath = getDebugFinalPath(path)
		if FileUtil.Path.getIfExists(filePath) then
			FileUtil.remove(filePath)
		end
		FileUtil.write(filePath, content)
	else
		error("Not in debug mode; cannot write to file system.")
	end
end

function Util.appendCSV(path: string, row: string, header: string?)
	if IS_DEBUG then
		local filePath = getDebugFinalPath(path)
		if not FileUtil.Path.getIfExists(filePath) and header then
			FileUtil.write(filePath, header)
		end
		FileUtil.append(filePath, row)
	else
		error("Not in debug mode; cannot write to file system.")
	end
end

return Util
