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
		TAGS.TYPES.BRICKCOLOR,
		TAGS.OPERATIONS.INIT,
	},
	{},
	function()
		return BrickColor.new()
	end :: any,
	100_000,
	1_000
)
