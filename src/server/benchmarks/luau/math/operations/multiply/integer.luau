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
		TAGS.OPERATIONS.MUL,
		TAGS.TYPES.NUMBER,
		TAGS.TYPES.INTEGER,
		TAGS.FINDINGS.NO_INTEGER_GAINS,
		TAGS.FINDINGS.BATCH_MATH_WITH_VECTOR3,
	},
	{
		Benchmark.Parameter.Integer.new("a"),
		Benchmark.Parameter.Integer.new("b"),
	},
	function(a: number, b: number)
		return a * b
	end :: any,
	100_000,
	1_000
)
