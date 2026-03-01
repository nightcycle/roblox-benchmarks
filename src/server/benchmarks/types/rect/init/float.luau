--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local TAGS = require(game.ReplicatedStorage.Shared.TAGS)
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		TAGS.TYPES.RECT,
		TAGS.OPERATIONS.INIT,
		TAGS.FINDINGS.NO_INTEGER_GAINS,
		TAGS.FINDINGS.INIT_RECT_WITH_VECTOR2,
	},
	{
		Benchmark.Parameter.Float.new("minX", nil, -1),
		Benchmark.Parameter.Float.new("minY", nil, -1),
		Benchmark.Parameter.Float.new("maxX", 1),
		Benchmark.Parameter.Float.new("maxY", 1),
	},
	function(minX: number, minY: number, maxX: number, maxY: number)
		return Rect.new(minX, minY, maxX, maxY)
	end :: any,
	100_000,
	1_000
)
