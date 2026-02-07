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
		Benchmark.Parameter.Integer.new("a"),
		Benchmark.Parameter.Integer.new("b"),
	},
	function(a: number, b: number)
		return a * b
	end :: any,
	100_000,
	1_000
)
