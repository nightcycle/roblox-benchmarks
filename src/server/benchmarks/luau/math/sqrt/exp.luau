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
		return value ^ 0.5
	end :: any,
	100_000,
	1_000
)
