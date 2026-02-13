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
		TAGS.OPERATIONS.INIT,
		TAGS.FINDINGS.VECTOR2_IS_SLOW,
	},
	{
		Benchmark.Parameter.Float.new("x"),
		Benchmark.Parameter.Float.new("y"),
	},
	function(x: number, y: number)
		return Vector3.new(x, y)
	end :: any,
	100_000,
	1_000
)
