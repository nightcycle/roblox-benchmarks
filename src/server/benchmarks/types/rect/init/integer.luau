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
		Benchmark.Parameter.Integer.new("minX", nil, -1),
		Benchmark.Parameter.Integer.new("minY", nil, -1),
		Benchmark.Parameter.Integer.new("maxX", 1),
		Benchmark.Parameter.Integer.new("maxY", 1),
	},
	function(minX: number, minY: number, maxX: number, maxY: number)
		return Rect.new(minX, minY, maxX, maxY)
	end :: any,
	100_000,
	1_000
)
