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
		TAGS.PATTERNS.NOISEMAP,
		TAGS.FINDINGS.MATH_NOISE_IS_WEIRD,
	},
	{
		Benchmark.Parameter.Float.new("x"),
	},
	function(x: number)
		return math.noise(x)
	end :: any,
	100_000,
	1_000
)
