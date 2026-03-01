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
		TAGS.OPERATIONS.CROSS,
		TAGS.FINDINGS.VECTOR2_IS_SLOW,
	},
	{
		Benchmark.Parameter.Vector3.new("a"),
		Benchmark.Parameter.Vector3.new("b"),
	},
	function(a: Vector3, b: Vector3)
		return a:Cross(b)
	end :: any,
	100_000,
	1_000
)
