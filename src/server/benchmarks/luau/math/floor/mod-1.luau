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
		Benchmark.Parameter.Float.new("value"),
	},
	function(value: number)
		return value - value % 1
	end :: any,
	10_000,
	100
)
