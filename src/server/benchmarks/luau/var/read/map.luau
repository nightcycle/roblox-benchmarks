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
		TAGS.TYPES.MAP,
		TAGS.TYPES.TABLE,
		TAGS.OPERATIONS.READ,
		TAGS.OPERATIONS.ASSIGN
	},
	{
		Benchmark.Parameter.Map.new(
			"array",
			Benchmark.Parameter.Literal.new("key", {"1", "2", "3"}),
			Benchmark.Parameter.Integer.new("value"),
			3,
			3
		),
	},
	function(array: { ["1" | "2" | "3"]: number })
		local _1 = array["1"]
		local _2 = array["2"]
		local _3 = array["3"]
	end :: any,
	100_000,
	1_000
)
