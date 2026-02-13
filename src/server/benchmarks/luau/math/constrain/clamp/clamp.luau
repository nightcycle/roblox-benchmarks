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
		TAGS.FINDINGS.CLAMP_IS_SLOW,
	},
	{
		Benchmark.Parameter.Float.new("v"),
		Benchmark.Parameter.Float.new("min", nil, -1),
		Benchmark.Parameter.Float.new("max", 1, nil),
	},
	function(v: number, min: number, max: number)
		return math.clamp(v, min, max)
	end :: any,
	100_000,
	1_000
)
