--!strict
-- Services
-- Packages
-- Modules
local Runner = require(game.ReplicatedStorage.Shared.Runner)
local SaveUtil = require(game.ReplicatedStorage.Shared.SaveUtil)
-- Types
-- Constants
local IS_FLAT = true
-- Variables
-- References
local Benchmarks = game.ServerScriptService.Server.benchmarks
-- Private Functions
-- Class
return function()
	local modules: { ModuleScript } = {}
	for i, v in Benchmarks:GetDescendants() do
		if v:IsA("ModuleScript") then
			table.insert(modules, v)
		end
	end
	local runners: { Runner.Runner } = {}
	for i, runModule in modules do
		table.insert(runners, Runner.new(runModule))
	end
	local isAlive = true
	local thr = task.spawn(function()
		SaveUtil.newSession()
		for i, runner in runners do
			if not isAlive then
				break
			end
			local summary = runner:solve(Random.new())
			runner:save(summary, IS_FLAT)
		end
	end)

	return function()
		isAlive = false
		if thr then
			task.cancel(thr)
		end
	end
end
