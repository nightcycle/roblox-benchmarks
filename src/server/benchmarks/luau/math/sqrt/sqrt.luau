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
		TAGS.LIBRARIES.MATH,
		TAGS.TYPES.NUMBER,
		TAGS.FINDINGS.MATH_SQRT_IS_SLOW,
	},
	{
		Benchmark.Parameter.Float.new("value", 0.01),
	},
	function(value: number)
		return math.sqrt(value)
	end :: any,
	100_000,
	1_000
)
