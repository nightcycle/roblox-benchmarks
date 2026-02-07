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
		Benchmark.Parameter.Float.new("v"),
		Benchmark.Parameter.Float.new("min"),
		Benchmark.Parameter.Float.new("max"),
	},
	function(v: number, min: number, max: number)
		if v < min then
			return min
		elseif v > max then
			return max
		else
			return v
		end
	end :: any,
	100_000,
	1_000
)
