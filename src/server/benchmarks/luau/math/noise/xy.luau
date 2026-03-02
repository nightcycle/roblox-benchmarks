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
	},
	function(x: number, y: number)
		return math.noise(x, y)
	end :: any,
	150_000,
	100
)
