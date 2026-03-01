--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local TAGS = require(game.ReplicatedStorage.Shared.TAGS)
local SIZE = 100
local VALUE_PARAM = Benchmark.Parameter.Integer.new("value")
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		TAGS.TYPES.ARRAY,
		TAGS.TYPES.TABLE,
		TAGS.OPERATIONS.WRITE,
		TAGS.FINDINGS.ARRAY_LENGTH_DOESNT_REALLY_MATTER,
	},
	{
		Benchmark.Parameter.Array.new("array", VALUE_PARAM, false, SIZE, SIZE),
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
