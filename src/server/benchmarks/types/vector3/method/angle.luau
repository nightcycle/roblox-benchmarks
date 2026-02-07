--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
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
