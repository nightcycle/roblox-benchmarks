--!strict
-- Services
-- Packages
-- Modules
local FileUtil = require(script.FileUtil)
local ENV = require(game.ReplicatedStorage.Shared.ENV)
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
function getFinalPath(path: string): string
	return ENV.DATA_DIR .. "/" .. path
end
function getParentDirectory(path: string): string
	local segments = path:split("/")
	table.remove(segments, #segments)
	return table.concat(segments, "/")
end
-- Class
local Util = {}

function Util.newSession()
	if ENV.IS_DEBUG then
		if FileUtil.Path.getIfExists(ENV.DATA_DIR) then
			FileUtil.run(`rm -rf "{ENV.DATA_DIR}"`)
		end
	else
		ENV.AGENT_OUTPUT.summary = ""
		table.clear(ENV.AGENT_OUTPUT.raw)
	end
end

function Util.saveCSV(path: string, content: string)
	local filePath = getFinalPath(path)
	if ENV.IS_DEBUG then
		local parentDir = getParentDirectory(filePath)
		if not FileUtil.Path.getIfExists(parentDir) then
			FileUtil.makeDirectories(parentDir)
		end
		if FileUtil.Path.getIfExists(filePath) then
			FileUtil.remove(filePath)
		end
		FileUtil.write(filePath, content)
	else
		ENV.AGENT_OUTPUT.raw[path] = content
	end
end

function Util.appendCSV(path: string, row: string, header: string?)
	row = "\n" .. row
	if ENV.IS_DEBUG then
		local filePath = getFinalPath(path)
		local parentDir = getParentDirectory(filePath)
		if not FileUtil.Path.getIfExists(parentDir) then
			FileUtil.makeDirectories(parentDir)
		end
		if not FileUtil.Path.getIfExists(filePath) and header then
			FileUtil.write(filePath, header)
		end
		FileUtil.append(filePath, row)
	else
		if ENV.AGENT_OUTPUT.summary == "" and header then
			ENV.AGENT_OUTPUT.summary = header
		end
		ENV.AGENT_OUTPUT.summary ..= row
	end
end

return Util
