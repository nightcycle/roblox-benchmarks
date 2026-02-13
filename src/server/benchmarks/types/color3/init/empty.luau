--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local TAGS = require(game.ReplicatedStorage.Shared.TAGS)
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		TAGS.TYPES.COLOR3,
		TAGS.OPERATIONS.INIT,
	},
	{},
	function()
		return Color3.new()
	end :: any,
	100_000,
	1_000
)
