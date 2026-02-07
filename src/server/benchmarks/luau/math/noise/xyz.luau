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
		Benchmark.Parameter.Float.new("x"),
		Benchmark.Parameter.Float.new("y"),
		Benchmark.Parameter.Float.new("z"),
	},
	function(x: number, y: number, z: number)
		return math.noise(x, y, z)
	end :: any,
	100_000,
	1_000
)
