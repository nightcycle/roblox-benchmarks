--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local TAGS = require(game.ReplicatedStorage.Shared.TAGS)
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		TAGS.TYPES.ARRAY,
		TAGS.TYPES.TABLE,
		TAGS.OPERATIONS.READ,
	},
	{
		Benchmark.Parameter.Array.new("array", Benchmark.Parameter.Integer.new("value"), true, 3, 3),
	},
	function(array: { number })
		local _1 = array[1]
		local _2 = array[2]
		local _3 = array[3]
	end :: any,
	100_000,
	1_000
)
