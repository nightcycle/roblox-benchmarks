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
		TAGS.TYPES.VECTOR3,
		TAGS.FINDINGS.VECTOR2_IS_SLOW,
		TAGS.FINDINGS.BATCH_MATH_WITH_VECTOR3,
	},
	{
		Benchmark.Parameter.Vector3.new("a"),
		Benchmark.Parameter.Vector3.new("b"),
	},
	function(a: Vector3, b: Vector3)
		return a * b
	end :: any,
	100_000,
	1_000
)
