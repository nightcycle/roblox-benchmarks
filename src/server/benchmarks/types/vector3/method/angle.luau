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
		TAGS.FINDINGS.VECTOR2_IS_SLOW,
	},
	{
		Benchmark.Parameter.Vector3.new("a"),
		Benchmark.Parameter.Vector3.new("b"),
		Benchmark.Parameter.Vector3.new("axis"),
	},
	function(a: Vector3, b: Vector3, axis: Vector3)
		return a:Angle(b, axis)
	end :: any,
	100_000,
	1_000
)
