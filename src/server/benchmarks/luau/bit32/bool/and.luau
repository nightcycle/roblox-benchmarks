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
		Benchmark.Parameter.Integer.new("a", 0, 2 ^ 32 - 1),
		Benchmark.Parameter.Integer.new("b", 0, 2 ^ 32 - 1),
	},
	function(a: number, b: number)
		return bit32.band(a, b)
	end :: any,
	250_000,
	100
)
