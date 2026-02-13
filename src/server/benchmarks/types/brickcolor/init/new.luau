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
		TAGS.FINDINGS.BRICKCOLOR_NEW_IS_ABSURDLY_SLOW,
	},
	{
		Benchmark.Parameter.Float.new("r", 0, 1),
		Benchmark.Parameter.Float.new("g", 0, 1),
		Benchmark.Parameter.Float.new("b", 0, 1),
	},
	function(r: number, g: number, b: number)
		return BrickColor.new(r, g, b)
	end :: any,
	100_000,
	1_000
)
