--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local TAGS = require(game.ReplicatedStorage.Shared.TAGS)
local RED_VAL = BrickColor.Red().Number
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		TAGS.TYPES.BRICKCOLOR,
		TAGS.OPERATIONS.INIT,
		TAGS.FINDINGS.BRICKCOLOR_NEW_IS_ABSURDLY_SLOW,
	},
	{},
	function()
		return BrickColor.palette(RED_VAL)
	end :: any,
	100_000,
	1_000
)
