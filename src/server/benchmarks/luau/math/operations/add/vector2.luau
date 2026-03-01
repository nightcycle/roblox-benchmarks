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
		TAGS.OPERATIONS.ADD,
		TAGS.TYPES.VECTOR2,
		TAGS.FINDINGS.VECTOR2_IS_SLOW,
	},
	{
		Benchmark.Parameter.Vector2.new("a"),
		Benchmark.Parameter.Vector2.new("b"),
	},
	function(a: Vector3, b: Vector3)
		return a + b
	end :: any,
	100_000,
	1_000
)
