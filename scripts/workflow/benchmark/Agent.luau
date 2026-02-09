-- < Parameters
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
local success, msg = pcall(function(...)
	print("Starting benchmark agent...")
	local Main = require(game.ReplicatedStorage.Shared.Main)
	Main()
	print("Benchmark agent completed.")
end)
if not success then
	print("Benchmark agent failed: " .. tostring(msg))
	return
end
return {
	isDebug = ENV.IS_DEBUG,
	filterPath = ENV.FILTER_PATH,
	data = ENV.AGENT_OUTPUT,
}
