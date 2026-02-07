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
		Benchmark.Parameter.Vector2.new("a"),
	},
	function(a: Vector2)
		return a:Abs()
	end :: any,
	100_000,
	1_000
)
