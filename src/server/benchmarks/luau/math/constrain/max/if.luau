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
		TAGS.OPERATIONS.IF,
		TAGS.OPERATIONS.LT,
		TAGS.FINDINGS.MINMAX_IS_SLOW,
	},
	{
		Benchmark.Parameter.Float.new("a"),
		Benchmark.Parameter.Float.new("b"),
	},
	function(a: number, b: number)
		if a > b then
			return a
		else
			return b
		end
	end :: any,
	100_000,
	1_000
)
