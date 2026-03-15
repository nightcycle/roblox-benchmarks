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
		for i, v in pairs(array) do
			local _ = v
		end
		return nil
	end :: any,
	1_000,
	100
)
