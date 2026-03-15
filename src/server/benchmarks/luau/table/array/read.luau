--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local CONSTANTS = require(game.ReplicatedStorage.Shared.CONSTANTS)
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		Benchmark.Parameter.Tuple.new({
			Benchmark.Parameter.Array.new("array", Benchmark.Parameter.Integer.new("value")),
			Benchmark.Parameter.Integer.new("index", 1, CONSTANTS.DEFAULT_TABLE_SIZE),
		}, function(array: { number }, index: number): ({ number }, number)
			local a = index / CONSTANTS.DEFAULT_TABLE_SIZE
			return array, math.clamp(math.round(a * #array), 1, #array)
		end),
	},
	function(array: { number }, index: number)
		return array[index]
	end :: any,
	1_000,
	100
)
