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
function getParentDirectory(path: string): string
	local segments = path:split("/")
	table.remove(segments, #segments)
	return table.concat(segments, "/")
end
-- Class
local Util = {}

function Util.newSession()
	if IS_DEBUG then
		if FileUtil.Path.getIfExists(DEBUG_PREFIX) then
			FileUtil.run(`rm -rf "{DEBUG_PREFIX}"`)
		end
	else
		error("Not in debug mode; cannot write to file system.")
	end
end

function Util.saveCSV(path: string, content: string)
	if IS_DEBUG then
		local filePath = getDebugFinalPath(path)
		local parentDir = getParentDirectory(filePath)
		if not FileUtil.Path.getIfExists(parentDir) then
			FileUtil.makeDirectories(parentDir)
		end
		if FileUtil.Path.getIfExists(filePath) then
			FileUtil.remove(filePath)
		end
		FileUtil.write(filePath, content)
	else
		error("Not in debug mode; cannot write to file system.")
	end
end

function Util.appendCSV(path: string, row: string, header: string?)
	row = "\n" .. row
	if IS_DEBUG then
		local filePath = getDebugFinalPath(path)
		local parentDir = getParentDirectory(filePath)
		if not FileUtil.Path.getIfExists(parentDir) then
			FileUtil.makeDirectories(parentDir)
		end
		if not FileUtil.Path.getIfExists(filePath) and header then
			FileUtil.write(filePath, header)
		end
		FileUtil.append(filePath, row)
	else
		error("Not in debug mode; cannot write to file system.")
	end
end

return Util
