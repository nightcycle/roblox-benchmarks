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
print("Starting benchmark agent...")
local Main = require(game.ReplicatedStorage.Shared.Main)
Main()
print("Benchmark agent completed.")
ENV.AGENT_OUTPUT.raw = {}
return {
	isDebug = ENV.IS_DEBUG,
	filterPath = ENV.FILTER_PATH,
	data = ENV.AGENT_OUTPUT,
}
