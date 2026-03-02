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
		Benchmark.Parameter.Vector2.new("b"),
	},
	function(a: Vector2, b: Vector2)
		return a - b
	end :: any,
	250_000,
	100
)
