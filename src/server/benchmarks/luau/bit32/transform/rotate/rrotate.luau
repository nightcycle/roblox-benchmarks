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
		Benchmark.Parameter.Integer.new("x", 0, 2 ^ 32 - 1),
		Benchmark.Parameter.Integer.new("disp", 0, 31),
	},
	function(x: number, disp: number)
		return bit32.rrotate(x, disp)
	end :: any,
	250_000,
	100
)
