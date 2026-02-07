--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local SIZE = 1_000
local VALUE_PARAM = Benchmark.Parameter.Integer.new("value")
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		Benchmark.Parameter.Array.new("array", VALUE_PARAM, true, SIZE, SIZE),
		Benchmark.Parameter.Integer.new("index", 1, SIZE),
		VALUE_PARAM,
	},
	function(array: { number }, index: number, value: number)
		array[index] = value
		return
	end :: any,
	100_000,
	1_000
)
