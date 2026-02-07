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
		Benchmark.Parameter.Integer.new("b", 1),
		Benchmark.Parameter.Integer.new("c", 1),
	},
	function(a: number, b: number, c: number)
		local _1, _2, _3 = a, b, c
	end :: any,
	100_000,
	1_000
)
