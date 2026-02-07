--!strict
-- Services
-- Packages
-- Modules
local ENV = require(game.ReplicatedStorage.Shared.ENV)
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

Util.log = function(str: string)
	if ENV.IS_VERBOSE then
		-- local t = DateTime.now():ToIsoDate()
		local src, _currentLine = debug.info(2, "sl")
		-- get text in quotes for src
		local name = src:match('"(.-)"')
		print(`{os.clock()}\t| {name}\t| {str}`)
	end
end
Util.wlog = function(str: string)
	if ENV.IS_VERBOSE then
		-- local t = DateTime.now():ToIsoDate()
		local src, _currentLine = debug.info(2, "sl")
		-- get text in quotes for src
		local name = src:match('"(.-)"')
		warn(`{os.clock()}\t| {name}\t| {str}`)
	end
end

return Util
