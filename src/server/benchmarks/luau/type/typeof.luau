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
		Benchmark.Parameter.Integer.new("a", 1),
	},
	function(a: number)
		local _ = typeof(a)
	end :: any,
	100_000,
	1_000
)
