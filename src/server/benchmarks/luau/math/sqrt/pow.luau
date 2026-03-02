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
		Benchmark.Parameter.Float.new("value", 0.01),
	},
	function(value: number)
		return math.pow(value, 0.5)
	end :: any,
	250_000,
	100
)
