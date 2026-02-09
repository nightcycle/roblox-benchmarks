--!strict
-- Services
-- Packages
-- Modules
local Runner = require(game.ReplicatedStorage.Shared.Runner)
local SaveUtil = require(game.ReplicatedStorage.Shared.SaveUtil)
local Logger = require(game.ReplicatedStorage.Shared.Logger)
local ENV = require(game.ReplicatedStorage.Shared.ENV)
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
function findFirstPath(path: string): Instance?
	local keys = string.split(path, "/")
	if keys[1] == "game" then
		table.remove(keys, 1)
	end
	local source: Instance = game
	local function index(i: number): Instance?
		local key = keys[i]
		if not key then
			return source :: any
		end

		local child = source:FindFirstChild(key)
		if not child then
			return nil
		end
		assert(child)
		source = child
		return index(i + 1)
	end
	return index(1)
end

-- Class
return function()
	Logger.log("\nstarting benchmark run...")
	local modules: { ModuleScript } = {}
	local filterPath = ENV.FILTER_PATH
	filterPath = filterPath:gsub("%./src/", "src/"):gsub("%.luau", "")
	filterPath = filterPath
		:gsub("src/server", "game/ServerScriptService/Server")
		:gsub("src/shared", "game/ReplicatedStorage/Shared")
		:gsub("src/client", "game/ReplicatedStorage/Client")
	local benchmarks = findFirstPath(filterPath)
	assert(benchmarks, `no instance found at {filterPath}`)
	for i, v in benchmarks:GetDescendants() do
		if v:IsA("ModuleScript") then
			table.insert(modules, v)
		end
	end
	local runners: { Runner.Runner } = {}
	for i, runModule in modules do
		table.insert(runners, Runner.new(runModule))
	end
	SaveUtil.newSession()
	for i, runner in runners do
		Logger.log(`\nrunning benchmark {i}/{#runners}`)
		local summary = runner:solve(Random.new())
		runner:save(summary, ENV.IS_FLAT)
	end
	Logger.log("benchmark run complete!\n")
end
