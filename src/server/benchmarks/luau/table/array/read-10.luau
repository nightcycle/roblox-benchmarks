--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local SIZE = 10
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		Benchmark.Parameter.Array.new("array", Benchmark.Parameter.Integer.new("value"), true, SIZE, SIZE),
		Benchmark.Parameter.Integer.new("index", 1, SIZE),
	},
	function(array: { number }, index: number)
		return array[index]
	end :: any,
	100_000,
	1_000
)
