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
		Benchmark.Parameter.Integer.new("v", 0, 2 ^ 32 - 1),
		Benchmark.Parameter.Integer.new("field", 0, 31),
		Benchmark.Parameter.Integer.new("width", 1, 31),
	},
	function(n: number, v: number, field: number, width: number)
		return bit32.replace(n, v, field, width)
	end :: any,
	250_000,
	100
)
