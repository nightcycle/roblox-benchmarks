--!strict
-- Services
-- Packages
-- Modules
local Parent = require(script.Parent)
local ENV = require(game.ReplicatedStorage.Shared.ENV)
local PathUtil = require(game.ReplicatedStorage.Shared.PathUtil)
local FileUtil = require(game.ReplicatedStorage.Shared.SaveUtil.FileUtil)
-- Types
-- Constants
local MAX_RUNS = 1
-- Variables
-- References
-- Private Functions
-- Class
return function()
	local target = game.ReplicatedStorage.Client.benchmarks
	local path = PathUtil.toPath(target)
	ENV.FILTER_PATH = path
	local thr = task.spawn(function()
		for i = 1, MAX_RUNS do
			print(`starting benchmark run {i} of {MAX_RUNS}...`)
			ENV.RUNNER_INDEX = i
			Parent()
		end
		FileUtil.run(`lune run "scripts/workflow/benchmark/summarize.lune.luau" "{ENV.DATA_DIR}"`)
		print("benchmark run complete, results saved to output directory")
	end)
	return function()
		task.cancel(thr)
	end
end
