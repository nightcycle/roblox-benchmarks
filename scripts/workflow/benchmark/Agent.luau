-- < Parameters
-- Services
-- Packages
-- Modules
local ENV = require(game.ReplicatedStorage.Shared.ENV)
local Main = require(game.ReplicatedStorage.Shared.Main)
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
Main()
return {
	isDebug = ENV.IS_DEBUG,
	filterPath = ENV.FILTER_PATH,
	data = ENV.AGENT_OUTPUT,
}
