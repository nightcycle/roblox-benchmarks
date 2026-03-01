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
		TAGS.TYPES.VECTOR3,
		TAGS.OPERATIONS.FUZZY_EQ,
		TAGS.FINDINGS.VECTOR2_IS_SLOW,
	},
	{
		Benchmark.Parameter.Vector3.new("a"),
		Benchmark.Parameter.Vector3.new("b"),
		Benchmark.Parameter.Float.new("value", 0.00001, 0.01),
	},
	function(a: Vector3, b: Vector3, epsilon: number?)
		return a:FuzzyEq(b, epsilon)
	end :: any,
	100_000,
	1_000
)
