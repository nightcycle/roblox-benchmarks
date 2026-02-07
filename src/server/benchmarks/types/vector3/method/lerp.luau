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
		Benchmark.Parameter.Float.new("alpha"),
	},
	function(a: Vector3, b: Vector3, alpha: number)
		return a:Lerp(b, alpha)
	end :: any,
	100_000,
	1_000
)
