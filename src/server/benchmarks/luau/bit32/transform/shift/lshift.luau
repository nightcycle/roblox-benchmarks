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
		Benchmark.Parameter.Integer.new("n", 0, 2 ^ 32 - 1),
		Benchmark.Parameter.Integer.new("disp", 0, 31),
	},
	function(n: number, disp: number)
		return bit32.lshift(n, disp)
	end :: any,
	250_000,
	100
)
