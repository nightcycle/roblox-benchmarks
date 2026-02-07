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
		Benchmark.Parameter.Array.new("array", Benchmark.Parameter.Integer.new("value"), true, 1, 1),
	},
	function(array: { number })
		for i = 1, #array do
			local _ = array[i]
		end
		return nil
	end :: any,
	100_000,
	1_000
)
