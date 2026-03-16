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
		Benchmark.Parameter.Array.new("array", Benchmark.Parameter.Integer.new("value")),
	},
	function(array: { number })
		local i = 1
		repeat
			local _ = array[i]
			i += 1
		until i > #array
		return nil
	end :: any,
	1_000,
	100
)
