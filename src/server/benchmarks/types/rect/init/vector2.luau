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
		Benchmark.Parameter.Vector2.new("min"),
		Benchmark.Parameter.Vector2.new("max"),
	},
	function(min: Vector2, max: Vector2)
		return Rect.new(min, max)
	end :: any,
	100_000,
	1_000
)
