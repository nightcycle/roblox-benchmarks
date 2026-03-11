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
	},
	function(n: number)
		return bit32.countrz(n)
	end :: any,
	250_000,
	100
)
