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
		Benchmark.Parameter.Float.new("r", 0, 1),
		Benchmark.Parameter.Float.new("g", 0, 1),
		Benchmark.Parameter.Float.new("b", 0, 1),
	},
	function(r: number, g: number, b: number)
		return Color3.new(r, g, b)
	end :: any,
	100_000,
	1_000
)
