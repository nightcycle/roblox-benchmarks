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
		TAGS.FINDINGS.INIT_RECT_WITH_VECTOR2,
	},
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
