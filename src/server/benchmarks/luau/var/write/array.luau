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
		local t = table.create(3)
		t[1] = a
		t[2] = b
		t[3] = c
	end :: any,
	100_000,
	1_000
)
