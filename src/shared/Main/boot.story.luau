--!strict
-- Services
-- Packages
-- Modules
local Parent = require(script.Parent)
local ENV = require(game.ReplicatedStorage.Shared.ENV)
local PathUtil = require(game.ReplicatedStorage.Shared.PathUtil)
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return function()
	local target = game.ServerScriptService.Server.benchmarks.luau.loop["for"]
	local path = PathUtil.toPath(target)
	ENV.FILTER_PATH = path
	local thr = task.spawn(Parent)
	return function()
		task.cancel(thr)
	end
end
