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
