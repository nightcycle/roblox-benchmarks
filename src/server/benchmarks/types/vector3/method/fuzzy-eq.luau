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
		Benchmark.Parameter.Float.new("value", 0.00001, 0.01),
	},
	function(a: Vector3, b: Vector3, epsilon: number?)
		return a:FuzzyEq(b, epsilon)
	end :: any,
	100_000,
	1_000
)
